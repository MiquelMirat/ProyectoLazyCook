//
//  RecipeType.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 12/04/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation
import UIKit

enum RecipeType: Int, CustomStringConvertible{
    
    case Breakfast
    case Brunch
    case Lunch
    case Snack
    case Dinner
    
    var description: String {
        switch self {
        case .Breakfast: return "Breakfast"
        case .Brunch: return "Brunch"
        case .Lunch: return "Lunch"
        case .Snack: return "Snack"
        case .Dinner: return "Dinner"
        }
    }
    
    static func fromString(type:String) -> RecipeType {
        switch type {
        case "Breakfast": return .Breakfast
        case "Brunch":  return .Brunch
        case "Lunch":   return .Lunch
        case "Snack":   return .Snack
        case "Dinner":  return .Dinner
        default:
            return .Snack
        }
        
    }
    
    static var count:Int { return 5 }
    
}
