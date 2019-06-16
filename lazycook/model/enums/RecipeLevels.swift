//
//  RecipeLevels.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 21/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation

enum RecipeLevels: Int, CustomStringConvertible {

    case EasyPeasy
    case TotallyDoable
    case YouCanDoIt
    case Challenge
    
    var description: String {
        switch self {
        case .EasyPeasy: return "Easy Peasy"
        case .TotallyDoable: return "Totally doable"
        case .YouCanDoIt: return "You can do it!"
        case .Challenge: return "Challenge!!"
        }
    }
    static var count:Int { return 4 }
    
}
