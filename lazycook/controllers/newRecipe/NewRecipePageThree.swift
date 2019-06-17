//
//  NewRecipePageThree.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 02/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase

class NewRecipePageThree: UIViewController {

    var recipe:Recipe?
    var db = Firestore.firestore()
    var manager = Manager.shared
    
    @IBOutlet weak var filtersTable: UITableView!
    @IBOutlet weak var postRecipeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filtersTable.delegate = self
        self.filtersTable.dataSource = self
        self.postRecipeButton.layer.cornerRadius = 10
        self.navigationItem.title = "Post Recipe"
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        //view.addGestureRecognizer(tap)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print("prepare page3")
        if segue.destination is AlergensViewController{
            let vc = segue.destination as? AlergensViewController
            print("prepare page3: count alergenos", self.recipe!.alergenos.count)
            vc?.selectedAlergens = self.recipe?.alergenos
        }
        if segue.destination is IngredientsViewController {
            let vc = segue.destination as? IngredientsViewController
            print("prepare page3: count ingredients", self.recipe!.ingredients.count)
            vc?.selectedIngredients = self.recipe?.ingredients
        }
        if segue.destination is NewRecipeViewController {
            let vc = segue.destination as? NewRecipeViewController
            vc?.recipe = Recipe()
        }
    }
    
    @IBAction func postRecipe(){
        testingFirebase()
        
    }
    func testingFirebase(){
        let db = Firestore.firestore()
        let storage_ref = Storage.storage().reference()
        let batch = db.batch()
        
        let recipe = self.recipe!
        recipe.cook_id = Auth.auth().currentUser!.uid
        let data = recipe.toArray()
        
        let id = db.collection("recipes").document().documentID
        let recipe_doc_ref = db.collection("recipes").document(id)
        //let recipe_storage_ref = storage_ref.child("recipeImages/\(id)")
        
        print("posting recipe with id: ",id)
        //POST RECIPE
        batch.setData(data, forDocument: recipe_doc_ref)
        //POST STEPS
        for (index, s) in recipe.steps!.enumerated() {
            let step_ref = recipe_doc_ref.collection("steps").document(String(index+1))
            batch.setData(s.toArray(), forDocument: step_ref)
        }
        print("BATCH COMMIT")
        batch.commit { (err) in
            if let err = err {
                print("Error writing BATCH: \(err)")
                
            } else {
                print("BATCH SUCCESFUL!")
                self.showSuccessAlert()
            }
        }
        //POST MAIN IMAGE
        print("POSTING MAIN IMAGE")
        let main_img_ref = storage_ref.child("recipeimages/\(id)").child("main.png")
        main_img_ref.putData(recipe.mainImage!.pngData()!, metadata: nil) { (m, e) in
            if let error = e {
                print("Error writing main image: \(error)")
            }else{
                print("main image posted succesfully")
            }
        }
        func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
        //FOR EACH STEP WITH IMAGE WE UPLOAD THE IMAGE TO STORAGE IN A FOLDER WITH THE RECIPE_ID AS NAME
        print("FOREACH STEPS")
        for (index, s) in recipe.steps!.enumerated() {
            print("foreach steps: index...", index)
            if s.hasImage() {
                print("this step hasImage")
                if let image_data = s.image?.pngData() {
                    storage_ref.child("recipeimages/\(id)/\(index + 1).png").putData(image_data, metadata: nil) { (metadata, err) in
                        if let error = err {
                            print("\(error) ERROR posting image at index", index)
                        }
                    }
                }
            }
        }
    }
    func showSuccessAlert(){
        let alertController = UIAlertController(title: "Felicidades", message: "Has publicado una receta", preferredStyle:UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("you have pressed OK button")
            self.performSegue(withIdentifier: "page3to1", sender: self)
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:{ () -> Void in
            //your code here
        })
    }

}



extension NewRecipePageThree: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("current indexPath", indexPath.row)
        let type = FilterOption(rawValue: indexPath.row)!
        switch type{
        case FilterOption.alergens: fallthrough
        case FilterOption.ingredients:
            let cell = self.filtersTable.dequeueReusableCell(withIdentifier: "filterLinkCell", for: indexPath) as? FilterLinkCell
            cell?.txtLabel.text = type.description
            return cell!
        case FilterOption.isVegan:
            let cell = self.filtersTable.dequeueReusableCell(withIdentifier: "controlCell", for: indexPath) as! ControlCell
            cell.descriptionLabel.text = type.description
            cell.controlSwitch.tag = indexPath.row
            cell.controlSwitch.isOn = recipe?.isVegan ?? false
            cell.controlSwitch.addTarget(self, action: #selector(handleSwitch(sender:)), for: .valueChanged)
            return cell
        case .difficulty: fallthrough
        case .cooking_time: fallthrough
        case .diners:
            let cell = self.filtersTable.dequeueReusableCell(withIdentifier: "pickerViewCell", for: indexPath) as! PickerViewCell
            cell.txtLabel.text = type.description
            cell.picker.tag = indexPath.row
            print("selected cell before getROW", cell.picker.selectedRow(inComponent: 0))
            cell.picker.selectRow(getRow(tag: cell.picker.tag), inComponent: 0, animated: false)
            print("selected cell after getROW", cell.picker.selectedRow(inComponent: 0))
            cell.picker.delegate = self
            cell.picker.dataSource = self
            return cell
        }
    }
    func getRow (tag:Int) -> Int {
        print("get ROW")
        switch tag {
        case 3:
            print("set difficulty")
            return recipe!.difficulty.rawValue
        case 4:print("set time")
            return (recipe!.cooking_time - 5) == 0 ? 0 : (recipe!.cooking_time - 5) / 5
        case 5:print("set diners")
            return recipe!.comensales - 1
        default:
            print("default at getROW")
            return 0
        }
        
    }
    
    @objc func handleSwitch(sender:UISwitch){
        print("switch changed")
        //tag 2 for vegan cell
        switch sender.tag {
        case 2:
            recipe?.isVegan = sender.isOn
            //print("sender is selected?", sender.isSelected)
            print("now this recipe is vegan", recipe!.isVegan)
            let change:[String: Bool] = ["veggie": sender.isOn]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switchSelected"), object: nil, userInfo: change)
            
            break
        default:
            break
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row at?")
        switch FilterOption(rawValue: indexPath.row) {
        case FilterOption.ingredients?:
            print("did select row at? ingrediets")
            performSegue(withIdentifier: "page3toIngredients", sender: self)
        case FilterOption.alergens?:
            print("did select row at? alergens")
            performSegue(withIdentifier: "page3toAlergens", sender: self)
        case FilterOption.isVegan?:
            
            break
        default:
            break
        }
        
    }
}
extension NewRecipePageThree: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 3 {
            return RecipeLevels.count
        }else if(pickerView.tag == 4){
            return 12
        }else if(pickerView.tag == 5){
            return 6
        }
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 3 {
            return RecipeLevels(rawValue: row)?.description
        }else if(pickerView.tag == 4){
            return String(row * 5 + 5)
        }else if(pickerView.tag == 5){
            return String(row + 1)
        }
        return "default"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 3 {
            recipe?.difficulty = RecipeLevels(rawValue: row)!
        }else if(pickerView.tag == 4){
            recipe?.cooking_time = row * 5 + 5
        }else if(pickerView.tag == 5){
            recipe?.comensales = row + 1
        }
        let pickers_data:[String:Int] = ["difficulty": recipe!.difficulty.rawValue,"time": recipe!.cooking_time,"diners":recipe!.comensales]
        
        NotificationCenter.default.post(name: Notification.Name("pickersChanged"), object: nil, userInfo: pickers_data)
    }
    
    
    
}
