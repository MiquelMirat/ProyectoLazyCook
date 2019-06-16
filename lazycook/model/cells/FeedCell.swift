//
//  FeedCell.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 25/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var feedDecription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
