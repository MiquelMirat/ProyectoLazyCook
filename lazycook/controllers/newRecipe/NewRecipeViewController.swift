//
//  NewRecipeViewController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 05/04/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase


class NewRecipeViewController: UIViewController {

    let storage = Storage.storage()
    var db = Firestore.firestore()
    var data:Data?
    var recipe:Recipe?
    var hasPickedImage:Bool = false {
        didSet{
            deleteImageBtn.isEnabled = hasPickedImage
            editingChanged()
        }
    }
    
    
    @IBOutlet weak var deleteImageBtn: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var recipeDescription: UITextView!
    @IBOutlet weak var recipeTypePicker: UIPickerView!
    @IBOutlet weak var btnAddImage: UIButton!
    
    
    
    @IBAction func goToPageTwo(_ sender: Any) {
        self.performSegue(withIdentifier: "page1to2", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("prepare page1")
        if segue.destination is NewRecipePageTwo
        {
            let vc = segue.destination as? NewRecipePageTwo
            vc?.recipe = self.recipe!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeDescription.delegate = self
        recipeTypePicker.delegate = self
        recipeTypePicker.dataSource = self
        self.navigationItem.title = "New Recipe"

        self.recipe = Recipe()
        setUpUI()
        setUpListeners()
        print("alergenos count: " , Alergenos.count)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        

    }
    func setUpUI(){
        recipeTitle.layer.cornerRadius = 5
        recipeTypePicker.layer.cornerRadius = 10
        recipeDescription.layer.cornerRadius = 10
        recipeImage.layer.cornerRadius = 10
        btnAddImage.layer.cornerRadius = 10
        
    }
    func setUpListeners(){
        [recipeTitle].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @objc func editingChanged(){
        print("editing")
        if(self.recipeTitle.text! != "" && self.recipeDescription.text! != "" && hasPickedImage){
            btnNext.isHidden = false
        }else{
            btnNext.isHidden = true
        }
    }
    
    @IBAction func deleteSelectedImage(_ sender: Any) {
        recipeImage.image = UIImage(named: "recipeDefault")
        recipe!.mainImage = nil
        hasPickedImage = false
    }
    
    
    

    
    
    func downloadImage() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let snakeRef = storageRef.child("profileimages/Snake-icon.png")
        snakeRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("ERROROROROROR", error.localizedDescription)
            }else{
                print("SUCCESSSSSS")
                //image = UIImage(data: data!)
                self.data = data!
                
                
            }
        }
        
    }

    func uploadRecipe(name:String, data:Data){
        let storageRef = storage.reference()
        
        let path:String = "recipeimages/" + name + ".jpg"
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child(path)
        
        // Upload the file to the path "images/rivers.jpg"
        riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard url != nil else {
                    print(url?.absoluteString ?? "defaultURL")
                    return
                }
            }
        }
    }
    @IBAction func upload(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = false
        self.present(picker,animated: true){
            
        }
        
        
    }

}


extension NewRecipeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("anyway")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //let data:Data = image.jpegData(compressionQuality: 1)!
            //let name:String = "test2"
            //uploadRecipe(name: name, data: data)
            recipeImage.image = image
            recipe?.mainImage = image
            self.hasPickedImage = true
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



extension NewRecipeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        editingChanged()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        recipe?.title = recipeTitle.text!
        recipe?.description = recipeDescription.text!
    }
    
}
extension NewRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RecipeType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RecipeType(rawValue: row)?.description
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.recipe?.type = RecipeType(rawValue: row)!
    }
    
}
