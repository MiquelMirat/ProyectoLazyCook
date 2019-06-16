//
//  Recipe.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 12/04/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase

class Recipe {
    var title:String
    var description:String
    var mainImage:UIImage?
    var steps:[Step]?
    var ingredients:[Ingredient]
    var alergenos:[Alergenos]
    var type:RecipeType
    var difficulty:RecipeLevels
    var comensales:Int
    var isVegan:Bool
    var cooking_time:Int
    var cook_id:String
    var recipe_id:String
    var ratings:[Double] = [Double]()
    
    
    init(document:QueryDocumentSnapshot){
        self.title = document.data()["title"] as! String
        self.description = document.data()["description"] as! String
        self.ingredients = [Ingredient]()
        for i in document.data()["ingredients"] as? Array ?? ["default_ingredient"] {
            self.ingredients.append(Ingredient(name: i))
        }
        self.alergenos = [Alergenos]()
        for i in document.data()["alergenos"] as? Array ?? ["default_Alergen"] {
            self.alergenos.append(Alergenos(rawValue: Int(i) ?? 0)!)
        }
        self.type = RecipeType.fromString(type: document.data()["type"] as! String)
        self.difficulty = RecipeLevels(rawValue: document.data()["difficulty"] as! Int)!
        self.comensales = document.data()["diners"] as! Int
        self.cooking_time = document.data()["time"] as! Int
        self.isVegan = document.data()["isVeggie"] as! Bool
        self.cook_id = document.data()["cook_id"] as! String
        self.recipe_id = document.documentID
    }
    init(document:DocumentSnapshot){
        self.title = document.data()!["title"] as! String
        self.description = document.data()!["description"] as! String
        self.ingredients = [Ingredient]()
        for i in document.data()!["ingredients"] as? Array ?? ["default_ingredient"] {
            self.ingredients.append(Ingredient(name: i))
        }
        self.alergenos = [Alergenos]()
        for i in document.data()!["alergenos"] as? Array ?? ["default_Alergen"] {
            self.alergenos.append(Alergenos(rawValue: Int(i) ?? 0)!)
        }
        self.type = RecipeType.fromString(type: document.data()!["type"] as! String)
        self.difficulty = RecipeLevels(rawValue: document.data()!["difficulty"] as! Int)!
        self.comensales = document.data()!["diners"] as! Int
        self.cooking_time = document.data()!["time"] as! Int
        self.isVegan = document.data()!["isVeggie"] as! Bool
        self.cook_id = document.data()!["cook_id"] as! String
        self.recipe_id = document.documentID
    }
    
    init(title:String, description:String, mainImage:UIImage, type:RecipeType, difficulty:RecipeLevels, ingredients:[Ingredient],isVegan:Bool, cooking_time:Int, cook_id:String, diners:Int, recipe_id:String){
        self.cook_id = cook_id
        self.title = title
        self.description = description
        self.mainImage = mainImage
        self.steps = [Step]()
        self.alergenos = [Alergenos]()
        self.ingredients = ingredients
        self.type = type
        self.difficulty = difficulty
        self.isVegan = isVegan
        self.cooking_time = cooking_time
        self.comensales = diners
        self.recipe_id = recipe_id
    }
    
    init(){
        self.title = "title"
        self.description = "description"
        self.cook_id = "admin"
        self.mainImage = UIImage(named: "recipeDefault")!
        self.steps = [Step]()
        self.steps?.append(Step(text: "Do this..."))
        self.alergenos = [Alergenos]()
        self.ingredients = [Ingredient]()
        self.type = .Breakfast
        self.isVegan = true
        self.cooking_time = 20
        self.difficulty = .EasyPeasy
        self.comensales = 1
        self.recipe_id = "default_id"
    }
    
    func toArray() -> [String:Any] {
        return ["title": self.title,
                "description": self.description,
                "cook_id": self.cook_id,
                "type": self.type.description,
                "difficulty": self.difficulty.rawValue,
                "isVeggie": self.isVegan,
                "time": self.cooking_time,
                "diners": self.comensales,
                "ingredients": self.ingredientsToArray(),
                "alergenos": self.alergenosToArray()]
    }
    
    func alergenosToArray() -> [String] {
        var data = [String]()
        for a in self.alergenos {
            data.append(a.name)
        }
        return data
    }
    
    func ingredientsToArray() -> [String] {
        var data = [String]()
        for i in self.ingredients {
            data.append(i.name)
        }
        return data
    }
    
    func isValid(alergensToAvoid:[Alergenos]) -> Bool {
        for a in self.alergenos {
            for avoid in alergensToAvoid {
                if a == avoid {
                    print(a.name, " equals ", avoid.name, " so the recipe with id ",self.recipe_id, " is not valid")
                    return false
                }
            }
        }
        return true
    }
    func contains(theseAndMore ingredients:[Ingredient]) -> Bool{
        var found = 0
        for self_ing in self.ingredients {
            for i in ingredients {
                if self_ing.name == i.name {
                    found+=1
                }
            }
        }
        return found == self.ingredients.count
    }
    func contains(theseOrLess ingredients:[Ingredient]) -> Bool{
        for ing in ingredients {
            var found = false
            for self_ing in self.ingredients {
                if ing.name == self_ing.name {
                    found = true
                }
            }
            if !found {
                print("la receta con id ",self.recipe_id, " no es valida porque no contiene algun ingrediente:", ing.name)
                return false
            }
        }

        return true
    }
    func isEasyEnough(for difficulty:RecipeLevels) -> Bool {
        return self.difficulty.rawValue <= difficulty.rawValue
    }
    
    
    
    
}
