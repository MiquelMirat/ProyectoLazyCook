//
//  Ingredient.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 12/04/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit


class Ingredient: NSObject {
    var name:String
    var glutenFree:Bool?
    var isSelected:Bool
    
    init(name:String,glutenFree:Bool){
        self.name = name
        self.glutenFree = glutenFree
        self.isSelected = false
    }
    init(name:String){
        self.name = name
        self.isSelected = false
    }
    
    
}
