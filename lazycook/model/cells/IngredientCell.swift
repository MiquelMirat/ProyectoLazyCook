//
//  IngredientCell.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 15/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {
    
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var selectedMark: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
