//
//  Search.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 23/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation

class Search {
    
    var max_difficulty:RecipeLevels
    var max_time:Int
    var ingredients:[Ingredient]
    var allergys:[Alergenos]
    var onlyVeggie:Bool
    var canBuy:Bool
    
    init(){
        self.max_difficulty = RecipeLevels.EasyPeasy
        self.max_time = 5
        self.allergys = [Alergenos]()
        self.ingredients = [Ingredient]()
        self.onlyVeggie = false
        self.canBuy = false
    }
    
    init(max_difficulty:RecipeLevels, max_time:Int, ingredients:[Ingredient], allergys:[Alergenos], onlyVeggie:Bool, canBuy:Bool){
        self.max_difficulty = max_difficulty
        self.max_time = max_time
        self.allergys = allergys
        self.ingredients = ingredients
        self.onlyVeggie = onlyVeggie
        self.canBuy = canBuy
    }
    
    
}
