//
//  SearchTableViewController.swift
//  BAT
//
//  Created by Tobias Lewinzon on 12/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseUI
import SafariServices

class SearchTableViewController: UITableViewController, ArticleFavoriter, UISearchBarDelegate, SFSafariViewControllerDelegate {
    
    
    var articles: [Article] = []
    var searchQuery = ""
    var loggedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Instancio el nib
        let nib = UINib(nibName: "GenericCellView", bundle: nil)
        //Lo registro en el tableView. Basicamente dice "Cada genericCell,instnaciamela con esta vista"
        self.tableView.register(nib, forCellReuseIdentifier: "genericCell")
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        
        
        getData()
        whoIsLoggedIn()
        
        let titleImageView = UIImageView(image: UIImage(named: "imgHeader"))
        self.navigationItem.titleView = titleImageView
    }
    
    func whoIsLoggedIn() {
        let refDatabase = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            refDatabase.child("users").child(userID).observeSingleEvent(of: DataEventType.value) { (DataSnapshot) in
                if let userData = DataSnapshot.value as? [String : AnyObject] { //La primera vez que te logueas, el userID no existe en firebase y este condicional en nil, por lo tanto no pasa anada. Pero al apretar un fav (ver lineas 106 en adelante)
                    let userObject = User(dictonary: userData) //Si hay un usuario, se ejecuta esto. Simplemente crea un objeto usuario (ver clase User) y lo guarda en loggedUser
                    self.loggedUser = userObject
                    
                    //Este for recorre el el array de favoritos y chequea si alguno esta cargado en la tabla. Los que encuentra les ejectua el toggleFavorite() para que aparezcan faveados.
                    for oneArticle in userObject.favorites {
                        if let index = self.articles.index(of: oneArticle) {
                            self.articles[index].toggleFavorite()
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let inputText = searchBar.text {
            searchQuery = inputText
            print(searchQuery)
            searchBar.resignFirstResponder()
            getData()
        }
    }
    
    func getData() {
        let theArticlesService = ArticlesService()
        theArticlesService.getArticlesFromDAOBySearch(query: searchQuery) { (searchResults) in
            print("Soy el search y recibo \(searchResults.count) articulos")
            self.articles = searchResults
            self.tableView.reloadData()
        }
    }
    
    func toggleFavorite(inCell: UITableViewCell) {
        if let positionInTable = tableView.indexPath(for: inCell) {
            let theArticle = articles[positionInTable.row]
            theArticle.toggleFavorite()
            
            let refDatabase = Database.database().reference()
            if let user = loggedUser {
                if theArticle.isFavorite { //Si el articulo quedo faveado despues de que se ejecute toggleFavorite en la linea 94, appendealo al array de favoritos de loggedUser y despues subilo a firebase.
                    user.favorites.append(theArticle)
                    refDatabase.child("users").child(user.ID).setValue(user.convertToDictonary())
                } else { //El usuario desfaveo. Tengo que 1- Encontrar el article en el array del user 2- Si aparece, borrarlo. 3- subir el usuario editado. Use el protocolo equatable para encontrar mas facil un article en un array de articles
                    for oneArtice in user.favorites {
                        if let positionInArray = user.favorites.index(of: theArticle) {
                            user.favorites.remove(at: positionInArray)
                            refDatabase.child("users").child(user.ID).setValue(user.convertToDictonary())
                        }
                    }
                }
            } else { //No encontro ningun usuario. loggedUser = nil. Hay que crear un objeto usuario, agregarle el article faveado, y subirlo a firebase. De esta manera, la proxima vez que entre a la app va a tener su usuario en la base de datos.
                if let user = Auth.auth().currentUser {
                    let userID = user.uid
                    if let email = user.email {
                        let userObject = User(ID: userID, email: email)
                        userObject.favorites.append(theArticle)
                        loggedUser = userObject
                        refDatabase.child("users").child(userID).setValue(userObject.convertToDictonary())
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if articles.count == 0 {
            self.tableView.setEmptyMessage("Busque entre noticias de todo el mundo!")
        }
        return articles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath)
        if let customCell = cell as? GenericTableViewCell {
            customCell.setup(article: articles[indexPath.row], delegateFavoriter: self, delegateHomeVC: nil)
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    //Presento el VC de detalle por codigo
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        print("\(article.url)")
        if let url = URL(string: article.url) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let selectedRow = tableView.indexPathForSelectedRow?.row {
//            let article = articles[selectedRow]
//
//        }
//    }
    

}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
