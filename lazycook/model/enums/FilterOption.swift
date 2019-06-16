//
//  FilterOption.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 17/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation


enum FilterOption: Int, CustomStringConvertible {
    
    static var count: Int { return 6 }
    
    case ingredients
    case alergens
    case isVegan
    case difficulty
    case cooking_time
    case diners
    
    var description: String {
        switch self {
        case .ingredients:
            return "Ingredients"
        case .alergens:
            return "Alergens"
        case .isVegan:
            return "Is veggan"
        case .difficulty:
            return "Difficulty level"
        case .cooking_time:
            return "Cooking time"
        case .diners:
            return "Diners"
        }
    }
    
    
}
