//
//  RecipeCell.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 22/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Cosmos

class RecipeCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var difficultyLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var cookLbl: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func awakeFromNib() {
        mainImage.layer.cornerRadius = 50
        mainImage.layer.shadowColor = UIColor.gray.cgColor
        mainImage.layer.shadowOpacity = 0.5
        mainImage.layer.shadowOffset = CGSize(width: 0, height: 0)
/*        cosmosView.settings.fillMode = .half
        cosmosView.rating = 2.5
        cosmosView.settings.updateOnTouch = false*/
    }

    
}
