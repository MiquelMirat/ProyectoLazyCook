//
//  PickerViewCell.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 22/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

class PickerViewCell: UITableViewCell {

    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
