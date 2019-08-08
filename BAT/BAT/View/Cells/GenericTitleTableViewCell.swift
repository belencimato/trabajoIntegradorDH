//
//  GenericTitleTableViewCell.swift
//  BAT
//
//  Created by Belen Cimato on 28/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit

class GenericTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Mis Noticias Favoritas"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
}
