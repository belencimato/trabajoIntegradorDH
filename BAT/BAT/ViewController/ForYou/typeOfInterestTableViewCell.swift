//
//  typeOfInterestTableViewCell.swift
//  BAT
//
//  Created by Belen Cimato on 15/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit

class typeOfInterestTableViewCell: UITableViewCell {
    @IBOutlet weak var typeOfSuggestLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var imageForSuggest: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
