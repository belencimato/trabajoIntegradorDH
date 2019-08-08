//
//  LoginAlertViewController.swift
//  BAT
//
//  Created by Agustin Garcia on 14/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth

class LoginAlertViewController: UIViewController, FUIAuthDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inicializamos Firebase UI y asignamos el delegate
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        // Configurar los providers que vamos a usar
        let providers: [FUIAuthProvider] = [FUIEmailAuth(), FUIGoogleAuth()]
        authUI?.providers = providers

        updateScreen()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backToNewsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var upsLabel: UILabel!
    

    @IBAction func loginTapped(_ sender: Any) {
        if let authUI = FUIAuth.defaultAuthUI() {
            let authViewController = authUI.authViewController()
            present(authViewController, animated: true) {
                self.updateScreen()
            }
            updateScreen()
        }
        updateScreen()
    }
//    @IBAction func backToNewsTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()
        do {
            try authUI?.signOut()
        } catch {
            print(error)
            print("sarasa")
        }
        updateScreen()
    }
    
    
    func updateScreen(){
        if Auth.auth().currentUser != nil{
            upsLabel.text = "Bravo!"
            messageLabel.text = "Te has logueado exitosamente"
            loginButton.isHidden = true
            backToNewsButton.isHidden = false
            logoutButton.isHidden = false
            self.dismiss(animated: true, completion: nil)
        } else {
            upsLabel.text = "UPS!"
            messageLabel.text = "No haz iniciado sesión todavía"
            backToNewsButton.isHidden = true
            logoutButton.isHidden = true
            loginButton.isHidden = false
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateScreen()
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
