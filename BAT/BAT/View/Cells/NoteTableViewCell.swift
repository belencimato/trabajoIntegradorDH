//
//  NoteTableViewCell.swift
//  BAT
//
//  Created by Belen Cimato on 05/08/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var noteTxtArea: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
