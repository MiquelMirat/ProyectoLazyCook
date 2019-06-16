//
//  Feed.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 26/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation
import Firebase
import UIKit


class Feed {
    var senderId:String
    var senderDisplayName:String
    var recieverId:String
    var recipeId:String
    var timestamp:Timestamp
    var thumbnail:UIImage?
    
    init(){
        self.senderId = "sender_default"
        self.recipeId = "recipe_default"
        self.recieverId = "reciever_default"
        self.senderDisplayName = "default_name"
        self.timestamp = Timestamp(date: Date())
    }
    init(document:QueryDocumentSnapshot){
        self.senderId = document.data()["userId"] as! String
        self.recipeId = document.data()["recipeId"] as! String
        self.recieverId = document.data()["cookId"] as! String
        self.senderDisplayName = document.data()["senderDisplayName"] as! String
        print("init feed", document.data()["timestamp"] as! Timestamp)
        self.timestamp = document.data()["timestamp"] as! Timestamp
    }
    init(sender:String, recipe:String, reciever:String, senderDisplayName:String, thumbnail:UIImage){
        self.senderId = sender
        self.recipeId = recipe
        self.recieverId = reciever
        self.senderDisplayName = senderDisplayName
        self.thumbnail = thumbnail
        self.timestamp = Timestamp(date: Date())
    }
    init(sender:String,recipe:String,reciever:String, senderDisplayName:String){
        self.senderId = sender
        self.recipeId = recipe
        self.recieverId = reciever
        self.senderDisplayName = senderDisplayName
        self.timestamp = Timestamp(date: Date())
    }
    
    
}
