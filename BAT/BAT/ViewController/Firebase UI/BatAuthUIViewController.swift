//
//  BatAuthUIViewController.swift
//  BAT
//
//  Created by Belen Cimato on 01/08/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import FirebaseUI

class BatAuthUIViewController: FUIAuthPickerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hago el seteo de la imagen q va a ir de fondo
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "loginBG")
        //cambio el content mode
        //        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        //para poder poner el BG hay q acceder adentro del scrollview y las capas
        if let scrollView = self.view?.subviews.first {
            scrollView.backgroundColor = UIColor.clear
            for aSubview in scrollView.subviews {
                aSubview.backgroundColor = UIColor.clear
            }
        }
        //para desp ponerle el Bg
        self.view?.insertSubview(imageViewBackground, at:0)
    }
}
