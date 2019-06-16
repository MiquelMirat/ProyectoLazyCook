//
//  MenuOption.swift
//  SideMenuTutorial
//
//  Created by Stephen Dowless on 12/12/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {

    case Settings
    
    var description: String {
        switch self {
        case .Settings: return "Settings"
        }
    }
    
    var image: UIImage {
        switch self {

        case .Settings: return UIImage(named: "baseline_settings_white_24dp") ?? UIImage()
        }
    }
}
