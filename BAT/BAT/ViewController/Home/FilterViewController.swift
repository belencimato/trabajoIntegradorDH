//
//  FilterViewController.swift
//  BAT
//
//  Created by Tobias Lewinzon on 11/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sourcesTableView: UITableView!
    
    var homeTableReference: HomeTableViewController?
    @IBOutlet weak var sectionsPickerView: UIPickerView!
    
    //Variables que guardan lo que  usuario va seleccionando en la pantalla. Al apretar save, se van al diccionario selectedAtributes
    var selectedSource = ""
    var selectedSection = ""
    
    var sourcesForTableView: [Source] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let authUI = FUIAuth.defaultAuthUI()
        do {
            try authUI?.signOut()
        } catch {
            print(error)
            print("sarasa")
        }
        
        
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
        sectionsPickerView.delegate = self
        sectionsPickerView.dataSource = self
        getSourcesForTableView()
        
        //TODO Falta ver como cambiar la font de el picker, probe con lo que esta comentado a continuacion y no funca
        
        
    }
    
    //PickerViw stuff
    let sectionsForPickerView = ["All", "Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sectionsForPickerView.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sectionsForPickerView[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //La primera posicion es "All", dejando el string vacio.
        if row == 0 {
            selectedSection = ""
        } else {
            selectedSection = "category=\(sectionsForPickerView[row].lowercased())"
        }
    }
    
    //TableView stuff
    func getSourcesForTableView() {
        let theArticlesService = ArticlesService()
        theArticlesService.getSourcesFromDAO { (sourcesFromService) in
            self.sourcesForTableView = sourcesFromService
            self.sourcesTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesForTableView.count
    }
    
    var oldIndexPath = IndexPath(row: 0, section: 0)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Esto me saca esa mierda que queda gris cuando selecciono una celda
        sourcesTableView.deselectRow(at: indexPath, animated: true)
        
        //Guardo la celda seleccionada en una varible
        let selectedCell = sourcesTableView.cellForRow(at: indexPath)
        
        if indexPath.row == 0 { //Si la posicion seleccionada es 0, se apreto "All sources", y mando un string vacio porque no quiero seleccionar una source.
            selectedSource = ""
            
            let oldCell = sourcesTableView.cellForRow(at: oldIndexPath)
            
            //Condicinales que cambian el estado del checkmark al seleccionar otra celda. Funciona guardando el indexPath en una variable, de manera que puedo accederlo en el proximo all de esta funcion, sabiendo que celda se tickeo anteriormente para destiquearla.
            if oldCell?.accessoryType == UITableViewCell.AccessoryType.checkmark {
                oldCell?.accessoryType = UITableViewCell.AccessoryType.none
            }
            if selectedCell?.accessoryType == UITableViewCell.AccessoryType.none {
                selectedCell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        } else {
            selectedSource = "?sources=\(sourcesForTableView[indexPath.row].id)"
            //Se repite la logica de arriba.
            let oldCell = sourcesTableView.cellForRow(at: oldIndexPath)
            
            //Condicinales que cambian el estado del checkmark.
            if oldCell?.accessoryType == UITableViewCell.AccessoryType.checkmark {
                oldCell?.accessoryType = UITableViewCell.AccessoryType.none
            }
            if selectedCell?.accessoryType == UITableViewCell.AccessoryType.none {
                selectedCell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        }
        oldIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { //Instancio la celda que dice "Al sources" al inicio de la tabla
            let cell =  sourcesTableView.dequeueReusableCell(withIdentifier: "all", for: indexPath)
            cell.textLabel?.text = "All sources"
            return cell
        } else {
            let cell = sourcesTableView.dequeueReusableCell(withIdentifier: "oneSource", for: indexPath)
            let theSource = sourcesForTableView[indexPath.row]
            cell.textLabel?.text = theSource.name
            
            //Como los indexPath se reutilizan, necesito saber cual es exactamente el que fue tickeado para que persista tickeado al scrollear.
            //Faltaria alguna logica que me lo deje tickeado al abrir el modal de vuelta, pero me da paja.
            if indexPath == oldIndexPath {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            return cell
        }
    }
    
    @IBAction func cancelTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTap(_ sender: Any) {
        //La API del orto presenta un problema: No puedo combinar los parametros source y section en un mismo request. Entonces, alguno de los dos o ambos debe estar vacio. Aca se chequea eso y se manda una alerta en caso de que falle. Si se cumple la condicion, se manda lo seleccionado al HomeTableVC.
        if selectedSource != "" && selectedSection != "" {
            let alert = UIAlertController(title: "Error", message: "Select either a source or a section", preferredStyle: UIAlertController.Style.alert)
            let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(button)
            present(alert, animated: true, completion: nil)
        } else {
            homeTableReference?.selectedSource = selectedSource
            homeTableReference?.selectedSection = selectedSection
            homeTableReference?.getData()
            dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
