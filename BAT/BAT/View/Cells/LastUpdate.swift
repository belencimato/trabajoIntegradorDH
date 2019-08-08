//
//  LastUpdate.swift
//  BAT
//
//  Created by Belen Cimato on 28/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit

class LastUpdate: UIView {
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    func setup(date:String){
        lastUpdateLabel.text = date
    }
}
