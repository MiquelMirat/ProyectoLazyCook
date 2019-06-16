//
//  CustomTabBarController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 22/03/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkGray], for: .normal)

        for i in 0...4 {
            tabBar.items![i].selectedImage = ItemTabBar(rawValue: i)?.iconSelected.withRenderingMode(.alwaysOriginal)
            tabBar.items![i].image = ItemTabBar(rawValue: i)?.iconNotSelected.withRenderingMode(.alwaysOriginal)
            tabBar.items![i].title = " "
            tabBar.items![i].imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        }
    }
    
}

