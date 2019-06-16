//
//  IngredientsViewController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 15/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase

class IngredientsViewController: UIViewController {

    @IBOutlet weak var ingredientsTable: UITableView!
    
    @IBOutlet weak var searchBar:UISearchBar?
    
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
        self.ingredientsTable.delegate = self
        self.ingredientsTable.dataSource = self
        searchBar?.delegate = self
        getAllIngredients()
        print("selected ingredients count: ", selectedIngredients.count)
        self.navigationItem.title = "LazyCook"
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func getAllIngredients(){
        if allIngredients != nil { return }
        allIngredients = [Ingredient]()
        db.collection("ingredients").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.allIngredients?.append(Ingredient(name: document.data()["name"] as! String))
                }
                self.ingredientsTable.reloadData()
                
            }
        }
    }
    

}
extension IngredientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredIngredients?.count ?? 0 : allIngredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var targetList = isSearching ? filteredIngredients : allIngredients
        let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
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
        let ingredientes:[String: [Ingredient]] = ["ingredientes": selectedIngredients]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ingredientSelected"), object: nil, userInfo: ingredientes)
        
        tableView.reloadData()
    }
    
    
    
    
    
}
extension IngredientsViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = searchBar.text != ""
        filteredIngredients = allIngredients?.filter { $0.name.contains(searchBar.text!) }
        self.ingredientsTable.reloadData()
    }
    
}
