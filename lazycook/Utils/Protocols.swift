//
//  Protocols.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 24/03/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

protocol ProfileViewControllerDelegate {
    func handleMenuToggle()
}
protocol HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
}
