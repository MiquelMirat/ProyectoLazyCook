//
//  Step.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 02/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation
import UIKit

class Step{
    var text:String
    var image:UIImage?
    
    init(text:String, image:UIImage){
        self.text = text
        self.image = image
    }
    init(text:String){
        self.text = text
    }
    init(){
        self.text = "Do this.."
        self.image = UIImage(named: "recipeDefault")!
    }
    
    func toArray() -> [String:Any]{
        return ["directions": text,
                "hasImage": self.image != nil ]
    }
    
    func hasImage() -> Bool{
        return self.image != nil
    }
}
