//
//  LastUpdateTableViewCell.swift
//  BAT
//
//  Created by Belen Cimato on 28/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit

class LastUpdateTableViewCell: UITableViewCell {
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(date:String){
        lastUpdateLabel.text = date
    }

}
