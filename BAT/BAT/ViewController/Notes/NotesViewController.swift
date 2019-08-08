//
//  NotesViewController.swift
//  BAT
//
//  Created by Belen Cimato on 05/08/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var txtSubTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newNoteLabel: UILabel!
    @IBOutlet weak var insertNoteInput: UITextField!
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes: [Note] = []
    var loggedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSubTitleLabel.text = "Espacio para tus"
        titleLabel.text = "Notas."
        newNoteLabel.text = "INGRESAR NUEVA ANOTACIÓN"
        // Do any additional setup after loading the view.
        
        let userService = CheckUserService()
        userService.passiveCheckUser(vc: self) { (user) in //Ejecuto la funcion passive get user, porque SI HAY un usuario, lo quiero saber y guardarlo, pero si no hay, no pasa nada. Dejamos al usuario ver noticias sin login.
            self.loggedUser = user
        }
        
        getNotes()
        
        let titleImageView = UIImageView(image: UIImage(named: "imgHeader"))
        self.navigationItem.titleView = titleImageView
        
        
    }
    // La siguiente funcion es para que traiga las notas de la base de datos y puedan ser cargadas en la table view
    func getNotes() {
        let refDatabse = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            refDatabse.child("users").child(userID).observe(DataEventType.value) { (DataSnapshot) in
                if let userData = DataSnapshot.value as? [String : AnyObject] {
                    let userObject = User(dictonary: userData)
                    self.notes = userObject.notes
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // La siguente funcion es para que el ok guarde las notas en la base de datos
    @IBAction func saveMessage(_ sender: Any) {
        if let user = loggedUser { //Si hay un usuario, se puede appendear notas
            let refDatabase = Database.database().reference()
            if let theNoteText = insertNoteInput.text, let theTitle = titleLabel.text {
                let theNote = Note(title: theTitle, text: theNoteText)
                user.appendNewNote(newNote: theNote)
                loggedUser = user //Despues de editar al user, lo guardo de vuelta en logged User
                refDatabase.child("users").child(user.ID).setValue(user.convertToDictonary())
                }
        } else { //No encontro ningun usuario. loggedUser = nil. Ejecutamos forceUser, para que si o si vaya al login
            print("FAVORITE FAILED: Username es nil. Abriendo login")
            let userService = CheckUserService()
            userService.forceChechUser(vc: self) { (user) in
                self.loggedUser = user
            }
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note-cell", for: indexPath)
        if let customCell = cell as? NoteTableViewCell {
            let note = self.notes[indexPath.row]
            customCell.noteTxtArea.text = note.text
        }
        return cell
    }

}
