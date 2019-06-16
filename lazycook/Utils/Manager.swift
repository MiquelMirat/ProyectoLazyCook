//
//  File.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 23/03/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation
import Firebase

class Manager {
    
    static let shared = Manager()
    let userDefaults = UserDefaults()
    let fs = FirebaseService.shared
    let db = Firestore.firestore()
    var actualUser:User?
    
    init(){
        print("initialization manager")
        if actualUser == nil {
            actualUser = retrieveFromUserDefaults()
        }
    }
    
    func manageAuthSuccess(result:AuthDataResult?, new:Bool) -> User {
        
        print("managing succes auth")
        let uid = result?.user.uid ?? ""
        let username = result?.additionalUserInfo?.username ?? ""
        let fullname = result?.user.displayName ?? ""
        let mail = result?.user.email ?? ""
        self.userDefaults.synchronize()
        self.actualUser = User(id: uid, username: username, mail: mail, fullname: fullname)
        if new { uploadUser(user: actualUser!)}
        self.userDefaults.set(true, forKey: "usersignedin")
        self.userDefaults.set(uid, forKey: "currentUserId")
        self.userDefaults.set(fullname, forKey: "currentUserFullname")
        self.actualUser!.storeToUserDefauts()
        return self.actualUser!
    }
    func uploadUser(user:User){
        db.collection("users").document(user.id).setData(user.toArray()) { (err) in
            if let err = err {
                print("error posting user after register, ERROR: ",err.localizedDescription)
            }
        }
    }
    
    func manageSignOutSuccess(){
        self.userDefaults.set(false, forKey: "usersignedin")
        userDefaults.set(nil, forKey: "actualUser")
        userDefaults.synchronize()
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
                print("retrieving... error, data is nil")
                
                return nil
            }
        }catch let error as NSError {
            print("error retrieving data from user default. ERROR: ", error.localizedDescription)
            let user = User()
            user.id = userDefaults.value(forKey: "currentUserId") as? String ?? ""
            user.fullname = userDefaults.value(forKey: "currentUserFullname") as? String ?? ""
            self.actualUser = user
            return user
        }
        
    }
    
    func getPOGO() -> Recipe {
        print("current user", Auth.auth().currentUser!.uid)
        
        var ing = [Ingredient]()
        ing.append(Ingredient(name: "cacao"))
        ing.append(Ingredient(name: "leche"))
        ing.append(Ingredient(name: "azucar"))
        ing.append(Ingredient(name: "lima"))
        
        var ale = [Alergenos]()
        ale.append(.gluten)
        ale.append(.altramuces)
        ale.append(.grano_sesamo)
        
        let recipe = Recipe(title: "pogo recipe", description: "it will have 3 steps, the first with image", mainImage: UIImage(named: "recipeDefault")!, type: .Breakfast, difficulty: .EasyPeasy, ingredients: ing, isVegan: false, cooking_time: 30, cook_id: Auth.auth().currentUser!.uid, diners: 1, recipe_id: "default_id")
        recipe.alergenos = ale
        recipe.steps?.append(Step(text: "to start (with image)", image: UIImage(named: "recipeDefault")!))
        recipe.steps?.append(Step(text: "to continue"))
        recipe.steps?.append(Step(text: "to finish"))
        
        return recipe
    }
    
}



