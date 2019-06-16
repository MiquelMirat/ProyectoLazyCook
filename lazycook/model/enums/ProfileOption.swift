//
//  ProfileOption.swift
//  lazycook
//
//  Created by Bernat Pons on 27/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

enum ProfileOption: Int, CustomStringConvertible {
    
    case Profile
    
    
    var description: String {
        switch self {
        case .Profile: return "Profile"
            
        }
    }
    
    
}

