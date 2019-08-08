//
//  CheckUser.swift
//  BAT
//
//  Created by Belen Cimato on 29/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Alamofire
import FirebaseUI
import FirebaseAuth
import FirebaseDatabase

class CheckUserService {
  //  var loggedUser: User?
    
    //instancio la variable para cambiar la UI de fondo
    //var customAuthPickerViewController : FIRAuthPickerViewController!
    
    func forceChechUser(vc: UIViewController, completion: @escaping ((User) -> Void )) { //Devuelve un usuario, o te manda al login
        if let rnm = NetworkReachabilityManager() {
            if rnm.isReachable {
                if Auth.auth().currentUser != nil { //Hay un usuario logueado
                    if let currentUser = Auth.auth().currentUser { //CHequeo si esta en firebase
                        let userID = currentUser.uid
                        let refDatabse = Database.database().reference()
                        refDatabse.child("users").observe(DataEventType.value) { (DataSnapshot) in
                            if DataSnapshot.hasChild(userID) { //El usuario ya esta cargado en firebase
                                refDatabse.child("users").child(userID).observe(DataEventType.value, with: { (DataSnapshot) in
                                    if let userAsDictonary = DataSnapshot.value as? [String : AnyObject] {
                                        let userObject = User(dictonary: userAsDictonary)
                                        completion(userObject)
                                        //Todo esto de arriba es lo que se repitee en condiciones normales. Log in, descargo el usuario de firebase, creo el objeto, lo devuelvo.
                                    }
                                })
                            } else { //No se encontro el usuatio en firebase. Hay que subirlo. Esto en teoria pasa unicamente cuando recien te logueas por primera vez.
                                let userID = currentUser.uid
                                if let email = currentUser.email {
                                    let newUser = User(ID: userID, email: email)
                                    refDatabse.child("users").child(userID).setValue(newUser.convertToDictonary())
                                    completion(newUser)
                                    //Primer logIn, ya se subio a la base de datos.
                                }
                            }
                        }
                    }
                } else { //No hay usuario. Ir al login
                    print("QUE PASA")
                    
                    let authUI = FUIAuth.defaultAuthUI()
                    authUI?.delegate = vc as? FUIAuthDelegate
                    
                    let providers: [FUIAuthProvider] = [FUIEmailAuth(), FUIGoogleAuth()]
                    authUI?.providers = providers
                    
                    if let authVC = authUI?.authViewController() {
                        vc.present(authVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    

    func passiveCheckUser(vc: UIViewController, completion: @escaping ((User) -> Void)) { //Chequea un usuario, devuelve un user o nil. No va al login
        if let rnm = NetworkReachabilityManager() {
            if rnm.isReachable {
                if Auth.auth().currentUser != nil { //Hay un usuario logueado
                    if let currentUser = Auth.auth().currentUser { //CHequeo si esta en firebase
                        let userID = currentUser.uid
                        let refDatabse = Database.database().reference()
                        refDatabse.child("users").observe(DataEventType.value) { (DataSnapshot) in
                            if DataSnapshot.hasChild(userID) { //El usuario ya esta cargado en firebase
                                refDatabse.child("users").child(userID).observe(DataEventType.value, with: { (DataSnapshot) in
                                    if let userAsDictonary = DataSnapshot.value as? [String : AnyObject] {
                                        let userObject = User(dictonary: userAsDictonary)
                                        completion(userObject)
                                    }
                                })
                            } else { //No se encontro el usuatio en firebase. Hay que subirlo. esto en teoria pasa unicamente cuando recien te logueas por primera vez
                                let userID = currentUser.uid
                                if let email = currentUser.email {
                                    let newUser = User(ID: userID, email: email)
                                    refDatabse.child("users").child(userID).setValue(newUser.convertToDictonary())
                                    completion(newUser)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
