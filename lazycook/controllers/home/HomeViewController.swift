//
//  ViewController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 22/03/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class HomeViewController: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    
    let userDefaults = UserDefaults()
    let manager = Manager.shared
    let db = Firestore.firestore()
    let st_ref = Storage.storage().reference()
    var recipes:[Recipe]?
    var selectedRecipe:Recipe?
    var following:[String]?
    
    @IBOutlet weak var recipeCollection: UICollectionView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeCollection.delegate = self
        self.recipeCollection.dataSource = self
        self.navigationItem.title = "Home"
        //self.recipeCollection.backgroundColor = .red
        print("HOME?")
        //configureImageView()
        downloadImage()
        getFollowings()
        fetchRecipes()

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipeDetailVC{
            let vc = segue.destination as? RecipeDetailVC
            vc?.recipeId = self.selectedRecipe!.recipe_id
            vc?.recipe = self.selectedRecipe!
        }
    }
    
    func getFollowings(){
        if self.following == nil { self.following = [String]() }
        db.collection("following").whereField("uid", isEqualTo: self.manager.actualUser!.id).getDocuments(completion: { (doc, err) in
            if err != nil { return }
            for u in doc!.documents {
                for f in u.data()["following"] as? Array ?? ["none"] {
                    self.following?.append(f)
                }
            }
            self.fetchRecipes()
        })
    }
    
    func fetchRecipes(){
        self.recipes = [Recipe]()
        for (index, f) in self.following!.enumerated() {
            
            db.collection("recipes").whereField("cook_id", isEqualTo: f).getDocuments { (snapshot, err) in
                if err != nil { return }
                for r in snapshot!.documents {
                    self.recipes?.append(Recipe(document: r))
                }
                if index == self.following!.endIndex - 1{
                    self.recipeCollection.reloadData()
                    self.fetchRecipeImages()
                    self.fetchRecipeRatings()
                }
                
            }
        }
        
    }
    func fetchRecipeRatings() {
        for (index, r) in self.recipes!.enumerated() {
            db.collection("stars").whereField("recipeId", isEqualTo: r.recipe_id).getDocuments { (snapshot, error) in
                if error != nil { return }
                for s in snapshot!.documents {
                    r.ratings.append(s.data()["rating"] as! Double)
                }
                
            }
            if index == self.recipes!.endIndex - 1{
                self.recipeCollection.reloadData()
            }
        }
    }
    func fetchRecipeImages(){
        for (index, r) in self.recipes!.enumerated(){
            st_ref.child("recipeimages/\(r.recipe_id)/main.png")
                .getData(maxSize: 20 * 1024 * 1024) { (data, err) in
                    if err != nil { return }
                    r.mainImage = UIImage(data: data!)
                    print("index: ", index)
                    self.recipeCollection.reloadData()
            }
        }
    }
    
    
    
    
    
    func downloadImage(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let snakeRef = storageRef.child("profileimages/Snake-icon.png")
        snakeRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("ERROROROROROR", error.localizedDescription)
            }else{
                print("SUCCESSSSSS")
                self.image.image = UIImage(data: data!)
            }
        }
        
    }
    func configureImageView(){
       
        
        self.view.addSubview(image)
        image.image = UIImage(named: "profile_")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    
    @IBAction func signOut(){
        print("signing out")
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
            manager.manageSignOutSuccess()
            performSegue(withIdentifier: "homeToLogin", sender: self)
            //userDefaults.set(false, forKey: "usersignedin")
            
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }


}
extension HomeViewController :UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as? RecipeCell
        cell?.mainImage.image = recipes?[indexPath.row].mainImage
        cell?.cosmosView.settings.fillMode = .half
        cell?.cosmosView.rating = recipes?[indexPath.row].ratings.count == 0 ? 2.5 : recipes![indexPath.row].ratings.average
        cell?.cosmosView.settings.updateOnTouch = false
        cell?.titleLbl.text = recipes?[indexPath.row].title
        cell?.descrLbl.text = recipes?[indexPath.row].description
        cell?.difficultyLbl.text = "Difficulty Level: " + recipes![indexPath.row].difficulty.description
        cell?.timeLbl.text = "Cooking time: " + String(recipes![indexPath.row].cooking_time)
        cell?.cookLbl.text = "Cook: " + recipes![indexPath.row].cook_id
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedRecipe = self.recipes![indexPath.row]
        self.performSegue(withIdentifier: "homeToRecipeDetail", sender: self)
    }
    
}





