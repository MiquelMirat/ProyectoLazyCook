//
//  User.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 22/03/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding{
    
    var id:String
    var username:String
    var mail:String
    var fullname:String?
    var likedRecipes:[String]? //recipes ids
    
    override init(){
        self.id = "test_id"
        self.username = "test_username"
        self.mail = "text_mail"
        self.fullname = "test_fullname"
    }
    
    init(id:String, username:String, mail:String, fullname:String) {
        self.id = id
        self.username = username
        self.mail = mail
        self.fullname = fullname
        self.likedRecipes = [String]()
    }
    
    func toArray()-> [String:Any] {
        return ["username":self.username,
                "mail":self.mail,
                "fullname":self.fullname ?? ""]
    }
    
    //Método que hace el encode para poder guardar las variables en user defaults
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(mail, forKey: "mail")
        aCoder.encode(fullname, forKey: "fullname")

    }
    //Método que recoje las variables y costruye un objecto user con ellas
    required convenience init(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: "username") as! String
        
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let mail = aDecoder.decodeObject(forKey: "mail") as! String
        let fullname = aDecoder.decodeObject(forKey: "fullname") as! String
        self.init(id: id, username: username, mail: mail, fullname: fullname)
    }

    func storeToUserDefauts(){
        do{
        let userDefaults = UserDefaults.standard
        let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        userDefaults.set(encodedData, forKey: "actualUser")
        userDefaults.synchronize()
        print("stored")
        }catch let error as NSError {
            print("error saving user into user defaults. ERROR: ", error.localizedDescription)
        }
    }
    func retrieveFromUserDefaults() -> User?{
        do{
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "actualUser")
        if decoded != nil {
            let decodedUser = try NSKeyedUnarchiver.unarchivedObject(ofClasses: .init(), from: decoded!) as! User?
            print("retrieved")
            return decodedUser
        }else{
            return nil
        }
        }catch let error as NSError {
            print("error retrieving data from user default. ERROR: ", error.localizedDescription)
            return nil
        }
        
    }
    
    
}

