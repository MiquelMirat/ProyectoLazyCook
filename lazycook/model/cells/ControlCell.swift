//
//  ControlCell.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 02/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

class ControlCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var controlSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
