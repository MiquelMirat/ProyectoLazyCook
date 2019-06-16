//
//  StepCell.swift
//  Testings
//
//  Created by Miquel Mirat Soler on 17/04/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//

import UIKit

class StepCell : UITableViewCell {
    
    @IBOutlet weak var newNoteText: UITextView!
    @IBOutlet weak var stepImage: UIImageView!
    @IBOutlet weak var deleteImage: UIButton!
    @IBOutlet weak var addImage: UIButton!
    
    override func awakeFromNib() {
        self.stepImage.layer.cornerRadius = 10
        self.newNoteText.layer.cornerRadius = 10
    }
    
}
