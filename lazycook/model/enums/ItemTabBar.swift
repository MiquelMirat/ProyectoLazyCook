//
//  TabBarItem.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 22/03/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation
import UIKit


enum ItemTabBar: Int, CaseIterable{
    case home
    case profile
    case new
    case search
    case feed
    
    var iconSelected: UIImage{
        switch self {
        case .home:
            return UIImage(named: "feed")!
        case .profile:
            return UIImage(named: "search")!
        case .new:
            return UIImage(named: "add")!
        case .search:
            return UIImage(named: "feedback")!
        case .feed:
            return UIImage(named: "profile")!
        }
    }
    var iconNotSelected: UIImage{
        switch self {
        case .home:
            return UIImage(named: "feed_")!
        case .profile:
            return UIImage(named: "search_")!
        case .new:
            return UIImage(named: "add_")!
        case .search:
            return UIImage(named: "feedback_")!
        case .feed:
            return UIImage(named: "profile_")!
        }
    }
}


