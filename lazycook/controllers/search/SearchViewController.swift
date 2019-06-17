//
//  SearchViewController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 22/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {

    @IBOutlet weak var filtersTable: UITableView!
    @IBOutlet weak var findButton: UIButton!
    
    var search:Search!
    var result:[Recipe]?
    
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTable.delegate = self
        filtersTable.dataSource = self
        filtersTable.separatorStyle = .none
        filtersTable.isScrollEnabled = false
        findButton.layer.cornerRadius = 10
        self.navigationItem.title = "Search"
        self.search = Search()
        self.result = [Recipe]()
        
        NotificationCenter.default.addObserver(self, selector: #selector(alergensSelected(_:)), name: Notification.Name(rawValue: "searchAlergenSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ingredientSelected(_:)), name: Notification.Name(rawValue: "searchIngredientSelected"), object: nil)
    }
    @objc func ingredientSelected(_ notification: Notification){
        if let array = notification.userInfo as? [String :[Ingredient]]{
            self.search?.ingredients = array["ingredients"]!
        }
    }
    @objc func alergensSelected(_ notification: Notification){
        if let array = notification.userInfo as? [String :[Alergenos]]{
            self.search?.allergys = array["alergenos"]!
        }

    }
    
    
    @objc func handleSwitch(sender:UISwitch){
        print("switch changed")
        //tag 2 for vegan cell
        switch sender.tag {
        case 4:
            search.onlyVeggie = sender.isOn
            //print("sender is selected?", sender.isSelected)
        case 5:
            search.canBuy = sender.isOn
        default:
            break
        }
        
    }
    
    @IBAction func findRecipes(_ sender: Any) {
        let recipeRef = db.collection("recipes")
        let query = recipeRef
            .whereField("time", isLessThanOrEqualTo: search.max_time)
            //.whereField("difficulty", isLessThanOrEqualTo: search.max_difficulty.rawValue)
        if search.onlyVeggie {
            query.whereField("isVeggie", isEqualTo: true)
        }
        query.getDocuments { (snapshot, err) in
            if err != nil {
                return
            }
            self.result?.removeAll()
            for document in snapshot!.documents {
                //result?.append(Recipe(document:))
                let recipe = Recipe(document: document)
                print("\(document.documentID) => \(document.data())")
                self.result?.append(recipe)
            }
            self.filterRecipes()
        }
    }
    func filterRecipes() {
        print("rresult count before filter", self.result!.count)
        if self.search.onlyVeggie {
            self.result = self.result!.filter({$0.isVegan == true})
        }
        print("after veggie filter", self.result!.count)
        self.result = self.result!.filter({$0.isEasyEnough(for: self.search!.max_difficulty)})
        
        print("after difficulty filter", self.result!.count)
        if self.search.allergys.count > 0 {
            self.result = self.result!.filter({$0.isValid(alergensToAvoid: search.allergys)})
        }
        print("after allergy filter", self.result!.count)
        if self.search.canBuy {
            self.result = self.result!.filter({$0.contains(theseAndMore: self.search.ingredients)})
        }else{
            self.result = self.result!.filter({$0.contains(theseOrLess: self.search.ingredients)})
        }
        print("after ingredient filter", self.result!.count)
        
        print("result after filter", self.result!.count)
        self.performSegue(withIdentifier: "searchToResult", sender: self)
    }
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SearchAlergenVC{
            let vc = segue.destination as? SearchAlergenVC
            vc?.selectedAlergens = self.search!.allergys
        }
        if segue.destination is SearchIngredientsVC {
            let vc = segue.destination as? SearchIngredientsVC
            vc?.selectedIngredients = self.search!.ingredients
        }
        if segue.destination is ResultsViewController {
            let vc = segue.destination as? ResultsViewController
            print("search_result: ", self.result!.count)
            vc?.resultRecipes = self.result!
        }
    }
    

}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchParameters.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select roww  searchview controller")
        switch SearchParameters(rawValue: indexPath.row) {
        case SearchParameters.ingredients?:
            performSegue(withIdentifier: "searchToIngredients", sender: self)
        case SearchParameters.alergens?:
            performSegue(withIdentifier: "searchToAlergens", sender: self)
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = SearchParameters(rawValue: indexPath.row)!
        switch type {
        case .alergens: fallthrough
        case .ingredients:
            let cell = filtersTable.dequeueReusableCell(withIdentifier: "filterLinkCell", for: indexPath) as? FilterLinkCell
            cell?.txtLabel.text = type.description
            return cell!
        case .difficulty:
            let cell = filtersTable.dequeueReusableCell(withIdentifier: "pickerViewCell", for: indexPath) as? PickerViewCell
            cell?.picker.delegate = self
            cell?.picker.dataSource = self
            cell?.picker.tag = indexPath.row
            cell?.txtLabel.text = type.description
            return cell!
        case .time:
            let cell = filtersTable.dequeueReusableCell(withIdentifier: "pickerViewCell", for: indexPath) as? PickerViewCell
            cell?.picker.delegate = self
            cell?.picker.dataSource = self
            cell?.picker.sizeToFit()
            cell?.picker.tag = indexPath.row
            cell?.txtLabel.text = type.description
            return cell!
            
        case .veggie: fallthrough
        case .canIbuy:
            let cell = filtersTable.dequeueReusableCell(withIdentifier: "controlCell", for: indexPath) as? ControlCell
            cell?.descriptionLabel.text = type.description
            cell?.controlSwitch.tag = indexPath.row
            cell?.controlSwitch.addTarget(self, action: #selector(SearchViewController.handleSwitch(sender:)), for: .valueChanged)
            
            return cell!
        }
        
        
        
    }
    
    
    
}
extension SearchViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 2:
            return RecipeLevels.count
        case 3:
            return 12
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 2:
            return RecipeLevels(rawValue: row)!.description
        case 3:
            return String(row * 5 + 5)
        default:
            return "default"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 2 {
            self.search.max_difficulty = RecipeLevels(rawValue: row)!
        }else if(pickerView.tag == 3){
            self.search.max_time = row * 5 + 5
        }
        
    }
    
    
}
