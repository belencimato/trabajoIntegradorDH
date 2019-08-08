//
//  HomeTableViewController.swift
//  BAT
//
//  Created by Tobias Lewinzon on 05/06/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseDatabase
import FirebaseAuth
import SafariServices


protocol ArticleFavoriter {
    func toggleFavorite(inCell: UITableViewCell)
}

class HomeTableViewController: UITableViewController, ArticleFavoriter, UserTapActionDelegate, FUIAuthDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var footerView: UILabel!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var isFavoriteBtn: UIButton!
    @IBOutlet weak var logOut: UIBarButtonItem!
    
    var articles: [Article] = []
    var loggedUser: User?
    
    //Variables que el FilterVC usa para mandar la data de lo que selecciono el usuaio aca. Se mandan por parametro al DAO en la funcion getData().
    var selectedSource = ""
    var selectedSection = ""
    //variable para delegate de celda collection
    var actualArticle: Article?
    //variable para almacenar el momento del ultimo refresh para xib de ultimo update
    var dateOfLastRefresh: String = "Actualiza la pantalla para ver la fecha"
    
    
    
    override func viewDidLoad() {
        //Instancio el nib
        let nib = UINib(nibName: "GenericCellView", bundle: nil)
        //Lo registro en el tableView. Basicamente dice "Cada genericCell,instnaciamela con esta vista"
        self.tableView.register(nib, forCellReuseIdentifier: "genericCell")

        super.viewDidLoad()
        
        getData()
        refreshDate()
        
        let userService = CheckUserService()
        userService.passiveCheckUser(vc: self) { (user) in //Ejecuto la funcion passive get user, porque SI HAY un usuario, lo quiero saber y guardarlo, pero si no hay, no pasa nada. Dejamos al usuario ver noticias sin login.
            self.loggedUser = user
        }

        //SETEO UNA IMG EN EL TITULO
        let titleImageView = UIImageView(image: UIImage(named: "imgHeader"))
        self.navigationItem.titleView = titleImageView
        
        //refresh data
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(sortArray), for: .valueChanged)
        self.refreshControl = refreshControl
        
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let aRandomIndexPath = Int.random(in: 0...20)
            let randomArticle = articles[aRandomIndexPath]
            
            if let url = URL(string: randomArticle.url) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
            
            
        }
    }
    
    
    
    //func sortArray para refresh
    @objc func sortArray() {
        getData()
        self.dateOfLastRefresh = refreshDate()
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    //funcion get data para tomar la fecha en la que se hace el refresh
    func refreshDate() -> String {
        dateOfLastRefresh = "\(Date())"
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return "Hoy, \(hour):\(minute)"
    }
    
    //func de delegate para collection cell
    func tappedItem(article: Article) {
        actualArticle = article
    }
    
    //funcion para desloguearse de Firebase
    @IBAction func logOutTapped(_ sender: Any) {
        //Tunné un poco esto para que te haga login/logout 😀
        if Auth.auth().currentUser != nil {
            do {
                let authUI = FUIAuth.defaultAuthUI()
                try authUI?.signOut()
                actualizarIconoDeLogout()
                self.loggedUser = nil //Al hacer logout, devolvemos a nil la variable del usuario.
            } catch {
                print(error)
            }
            
        } else { //Si se apreya el icono y NO hay un usuario, ejecutamos forceUser. Que va a mandarnos al login.
            let userService = CheckUserService()
            userService.forceChechUser(vc: self) { (user) in
                self.loggedUser = user
            }
        }
    }
    
    //Funcion para actualizar icono del botón de logout
    func actualizarIconoDeLogout() -> Void{
        if let user = Auth.auth().currentUser {
            // Si estas logueado muestra el icono de sign out
            //BELU POR FAVOR PONÉ MAYÚSCULAS EN LOS COMMENTS PORQUE LO RESOLVEMOS A LOS BIFES
            print("Icono de sign out")
            logOut.image = UIImage(named: "sign-out2")
        } else {
            // Si no estas logueado muestra el icono para sign in
            print("Icono de login")
            logOut.image = UIImage(named: "sign-in")
        }
    }
    
    func getData() {
        let theArticlesService = ArticlesService()
        theArticlesService.getArticlesFromDAO(source: selectedSource, section: selectedSection) { (articlesFromService) in
            self.articles = articlesFromService
            self.tableView.reloadData()
        }
    }
    
    func toggleFavorite(inCell: UITableViewCell) {
            if let user = loggedUser { //Si hay un usuario, se puede favoritear.
                
                let refDatabase = Database.database().reference()
                if let positionInTable = tableView.indexPath(for: inCell) {
                    let theArticle = articles[positionInTable.row]
                    theArticle.toggleFavorite()
                
                
                if theArticle.isFavorite { //Si el articulo quedo faveado despues de que se ejecute toggleFavorite, appendealo al array de favoritos de loggedUser y despues subilo a firebase.
                    user.favorites.append(theArticle)
                    loggedUser = user //Despues de editar al user, lo guardo de vuelta en logged User
                    refDatabase.child("users").child(user.ID).setValue(user.convertToDictonary())
                } else { //El usuario desfaveo. Tengo que 1- Encontrar el article en el array del user 2- Si aparece, borrarlo. 3- subir el usuario editado. Usé el protocolo equatable para encontrar mas facil un article en un array de articles
                    for oneArtice in user.favorites {
                        if let positionInArray = user.favorites.index(of: theArticle) {
                            user.favorites.remove(at: positionInArray)
                            loggedUser = user
                            refDatabase.child("users").child(user.ID).setValue(user.convertToDictonary())
                        }
                    }
                }
            }
            } else { //No encontro ningun usuario. loggedUser = nil. Ejecutamos forceUser, para que si o si vaya al login
                print("FAVORITE FAILED: Username es nil. Abriendo login")
                    let userService = CheckUserService()
                userService.forceChechUser(vc: self) { (user) in
                    self.loggedUser = user
                }
            }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        actualizarIconoDeLogout()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "main-cell", for: indexPath)
            if let customCell = cell as? MainNewsTableViewCell {
                customCell.setup(article: articles[indexPath.row], delegateFavoriter: self, delegateHomeTable: self)
                customCell.delegateFavoriter = self
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "collection-cell", for: indexPath)
            if let customCell = cell as? ForCollectionCellTableViewCell {
                customCell.setup(articles: articles, delegate: self)
                customCell.delegateHomeTable = self
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath)
            if let customCell = cell as? GenericTableViewCell {
                customCell.setup(article: articles[indexPath.row], delegateFavoriter: self, delegateHomeVC: self)
            }
            return cell
        }
    }
    
    //Le asigno las 2 medidas de celdas
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 325
        }else{
            return 177
        }
    }
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let article = articles[indexPath.row]
            if let url = URL(string: article.url) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    //Header section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let nib = Bundle.main.loadNibNamed("LastUpdateView", owner: self, options: nil)        // [ Any ]?
        let theView = nib?.first    // Any?
        
        if let headerView = theView as? LastUpdate {
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            headerView.setup(date: "Hoy, \(hour):\(minute)")
            return headerView
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? FilterViewController {
            detailVC.homeTableReference = self
        }
    }

    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return BatAuthUIViewController(authUI: authUI)
    }
//    //funcion para ponerle una img de fondo
//    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
//        return FUICustomAuthPickerViewController(nibName: "BatAuthUIViewController",
//                                                 bundle: Bundle.main,
//                                                 authUI: authUI)
//    }
    
}
