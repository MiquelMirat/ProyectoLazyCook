//
//  IngredientsViewController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 15/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase

class SearchIngredientsVC: UIViewController {
    

    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var db = Firestore.firestore()
    var selectedIngredients:[Ingredient]!
    var allIngredients:[Ingredient]?
    var filteredIngredients:[Ingredient]?
    var isSearching:Bool = false {
        didSet {
            ingredientsTable.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "LazyCook"

        self.ingredientsTable.delegate = self
        self.ingredientsTable.dataSource = self
        self.searchBar.delegate = self
        
        getAllIngredients()
        print("selected ingredients count: ", selectedIngredients.count)
        
    }
    
    func getAllIngredients(){
        if allIngredients != nil { return }
        allIngredients = [Ingredient]()
        db.collection("ingredients").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    //document.data()["name"]
                    self.allIngredients?.append(Ingredient(name: document.data()["name"] as! String))
                    
                }
                self.ingredientsTable.reloadData()
                
            }
        }
    }
    
    
}
extension SearchIngredientsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredIngredients?.count ?? 0 : allIngredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        var targetList = isSearching ? filteredIngredients : allIngredients
        cell.ingredientName.text = targetList?[indexPath.row].name
        cell.selectedMark.isHidden = !isSelected(ingredient:targetList![indexPath.row])
        return cell
        
    }
    func isSelected(ingredient:Ingredient) -> Bool{
        for i in selectedIngredients! {
            if ingredient.name == i.name {
                return true
            }
        }
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        var targetList = isSearching ? filteredIngredients : allIngredients
        if isSelected(ingredient: targetList![indexPath.row]) {
            selectedIngredients = selectedIngredients.filter { $0.name != targetList![indexPath.row].name }
        }else{
            selectedIngredients.append(targetList![indexPath.row])
        }
        print("selected ", indexPath.row)
        print("ingredient count changed: ", selectedIngredients.count)
        
        //self.allIngredients![indexPath.row].isSelected.toggle()
        let ingredientes:[String: [Ingredient]] = ["ingredients": selectedIngredients]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchIngredientSelected"), object: nil, userInfo: ingredientes)
        
        tableView.reloadData()
    }
    
}
extension SearchIngredientsVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = searchBar.text != ""
        filteredIngredients = allIngredients?.filter { $0.name.contains(searchBar.text!) }
        self.ingredientsTable.reloadData()
    }
    
}
