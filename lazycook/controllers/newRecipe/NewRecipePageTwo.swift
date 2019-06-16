//
//  NewRecipePageTwo.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 27/04/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

class NewRecipePageTwo: UIViewController {

    @IBOutlet weak var stepsTable: UITableView!
    @IBOutlet weak var nextPageBtn: UIButton!
    
    var recipe:Recipe?
    var currentTarget:Int?
    
    var tapGesture:UIGestureRecognizer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recipe Steps"

        setUpStepsTableView()
        self.nextPageBtn.layer.cornerRadius = 10
        print("recipe title", recipe!.title)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageToStep(sender:)))

        
        NotificationCenter.default.addObserver(self, selector: #selector(alergensChanged(_:)), name: Notification.Name(rawValue: "alergenSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ingredientChanged(_:)), name: Notification.Name(rawValue: "ingredientSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchChanged(_:)), name: Notification.Name(rawValue: "switchSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pickersChanged(_:)), name: Notification.Name(rawValue: "pickersChanged"), object: nil)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear: alergen_count", recipe!.alergenos.count)
    }
    
    @objc func alergensChanged(_ notification:Notification){
        print("page2 alergen changed")
        if let array = notification.userInfo as? [String :[Alergenos]]{
            self.recipe?.alergenos = array["alergenos"]!
        }
    }
    @objc func pickersChanged(_ notification:Notification) {
        print("pickers_changed")
        if let data = notification.userInfo as? [String:Int]{
            recipe?.cooking_time = data["time"]!
            recipe?.comensales = data["diners"]!
            recipe?.difficulty = RecipeLevels(rawValue: data["difficulty"]!)!
        }
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @objc func switchChanged (_ notification:Notification) {
        if let isVeggie = notification.userInfo as? [String:Bool] {
            self.recipe?.isVegan = isVeggie["veggie"]!
        }
    }
    @objc func ingredientChanged(_ notification:Notification){
        print("page2 ingredient changed")
        if let array = notification.userInfo as? [String :[Ingredient]]{
            self.recipe?.ingredients = array["ingredientes"]!
        }
    }
    
    @IBAction func gotToPageThree(_ sender: Any) {
        //self.performSegue(withIdentifier: "page2toIngredients", sender: self)
        //self.performSegue(withIdentifier: "page2toAlergens", sender: self)
        self.performSegue(withIdentifier: "page2to3", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print("prepare page2")
        if segue.destination is NewRecipePageThree{
            let vc = segue.destination as? NewRecipePageThree
            vc?.recipe = self.recipe!
        }
    }
    
    
    
    func setUpStepsTableView() {
        self.stepsTable.delegate = self
        self.stepsTable.dataSource = self
        self.stepsTable.allowsSelection = false
        self.stepsTable.separatorStyle = .none
    }
    
    
    @IBAction func appendStep(_ sender: Any) {
        print("new Step")
        self.recipe!.steps?.append(Step())
        var indexPaths = [IndexPath]()
        indexPaths.append(IndexPath(row: self.recipe!.steps!.count-1, section: 0))
        stepsTable.insertRows(at: indexPaths, with: .top)
    }
    
    @objc func addImageToStep(sender:UIGestureRecognizer){
        print("adding image to step")
        print(sender.view!.tag)
        self.currentTarget = sender.view!.tag
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = false
        self.present(picker,animated: true){
            
        }
    }
    @objc func deleteImageFromStep(sender:UIButton){
        let tag = sender.tag
        recipe!.steps![tag].image = nil
        stepsTable.reloadData()
        print("deleting image to step" , tag)
    }
  

}

extension NewRecipePageTwo : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.recipe!.steps.count
        return self.recipe!.steps!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath) as? StepCell
        cell?.newNoteText.text = self.recipe!.steps![indexPath.row].text
        cell?.newNoteText.tag = indexPath.row
        cell?.newNoteText.delegate = self
        //cell?.newNoteText!.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .valueChanged)
        cell?.stepImage.image = self.recipe!.steps![indexPath.row].image ?? UIImage(named: "recipeDefault")!
        cell?.stepImage.tag = indexPath.row
        cell?.stepImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addImageToStep(sender:))))
        cell?.deleteImage.addTarget(self, action: #selector(deleteImageFromStep(sender:)), for: .touchUpInside)
        cell?.deleteImage.tag = indexPath.row
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    @objc func textFieldDidChange(_ :Any){
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            self.recipe!.steps?.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
}
extension NewRecipePageTwo : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("anyway")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recipe!.steps![currentTarget!].image = image
            self.stepsTable.reloadData()
        }else{
            print("error")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
}
extension NewRecipePageTwo: UITextViewDelegate {

    func textViewDidEndEditing(_ textView: UITextView) {
        self.recipe!.steps![textView.tag].text = textView.text
        print("did end editing")
    }
    
}


