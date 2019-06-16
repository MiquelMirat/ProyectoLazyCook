//
//  AlergenCell.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 16/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

class AlergenCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var selectionMark: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
