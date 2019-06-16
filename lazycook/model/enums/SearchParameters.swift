//
//  SearchParameters.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 23/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation


enum SearchParameters: Int, CustomStringConvertible {
    case ingredients
    case alergens
    case difficulty
    case time
    case veggie
    case canIbuy
    
    
    var description: String {
        switch self {
        case .ingredients: return "Which ingredients do I have?"
        case .alergens: return "Am i allergic to someth?"
        case .time: return "How much time do i have?"
        case .difficulty: return "How cook do I feel today?"
        case .veggie: return "Am I veggie?"
        case .canIbuy: return "Can I buy something else?"
        }
    }
    
    static var count:Int{ return 6 }
    
    
    
}
