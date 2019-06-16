//
//  FirebaseService.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 26/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService: NSObject {
    let constantToNeverTouch = FirebaseApp.configure()
    static let shared = FirebaseService()
    
    override init() {
    }
}
