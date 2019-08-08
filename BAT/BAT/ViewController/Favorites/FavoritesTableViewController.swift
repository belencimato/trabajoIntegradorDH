//
//  FavoritesTableViewController.swift
//  BAT
//
//  Created by Tobias Lewinzon on 28/06/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth
import FirebaseDatabase
import SafariServices

class FavoritesTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    var articles: [Article] = []
    var loggedUser: User?
    

    override func viewDidLoad() {
        
        //Instancio los nibs
        let nib = UINib(nibName: "GenericCellView", bundle: nil)
        

        //Lo registro en el tableView. Basicamente dice "Cada genericCell,instnaciamela con esta vista"
        self.tableView.register(nib, forCellReuseIdentifier: "genericCell")
        
        
        super.viewDidLoad()
        
        getFavorites()
        
        //refresh data
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(sortArray), for: .valueChanged)
        self.refreshControl = refreshControl
        
        let titleImageView = UIImageView(image: UIImage(named: "imgHeader"))
        self.navigationItem.titleView = titleImageView
        
    }
    //func sortArray para refresh
    @objc func sortArray() {
        getFavorites() 
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    
    //Para recargar los favoritos, hay que salir de la tab y volver a entrar.
    //Implementar scroll to refresh y que se ejecute la funcion getFavorites. Despues borrar el viewDidAppear, ya no haria falta.
    override func viewDidAppear(_ animated: Bool) {
        let userService = CheckUserService()
        userService.forceChechUser(vc: self) { (user) in
            self.loggedUser = user
            self.getFavorites()
        }
    }
    
    func getFavorites() {
        let refDatabse = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            refDatabse.child("users").child(userID).observe(DataEventType.value) { (DataSnapshot) in
                if let userData = DataSnapshot.value as? [String : AnyObject] {
                    let userObject = User(dictonary: userData)
                    self.articles = userObject.favorites
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func removeFavorite(article: Article) {
        if let user = loggedUser {
            if let position = articles.firstIndex(of: article) {
                user.favorites.remove(at: position)
                self.loggedUser = user
                //Articulo removido del objeto usuario, ahora subo a Fireabase
                let databaseRef = Database.database().reference()
                databaseRef.child("users").child(user.ID).setValue(loggedUser?.convertToDictonary())
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeFavorite(article: articles[indexPath.row])
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath)
        let article = articles[indexPath.row]
        //celdaParaTitular
//        if let customCell = cell as? GenericTitleView {
//            customCell.titleLabel.text = "Mis noticias favoritas"
//        }
        //celda xib de favoritos
        if let customCell = cell as? GenericTableViewCell {
            customCell.setup(article: article, delegateFavoriter: nil, delegateHomeVC: nil)
            customCell.isFavoriteBtn.isHidden = true
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let nib = Bundle.main.loadNibNamed("GenericTitleView", owner: self, options: nil)        // [ Any ]?
<<<<<<< HEAD
        let theView = nib?.first    // Any?

        if let headerView = theView as? GenericTableViewCell {
            headerView.setup(title: "Mis notas favoritas")
            return headerView
=======
        if let theView = nib?.first as? UIView {
            return theView
>>>>>>> c4d8c638036afd596af42b381a6ff7c7940af5e1
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        print("\(article.url)")
        if let url = URL(string: article.url) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
