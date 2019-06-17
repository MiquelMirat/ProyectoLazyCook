//
//  RecipeDetailVC.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 25/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase
import Cosmos



class RecipeDetailVC: UIViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeDescr: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeDifficulty: UILabel!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    var recipeId:String!
    var recipe:Recipe?
    var ratings:[Double]?
    let db = Firestore.firestore()
    let st = Storage.storage()
    let manager = Manager.shared
    let initialRating = 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getRecipeById()
        self.loadUI()
        self.navigationItem.title = "LazyCook"

    }
    func getRecipeById(){
        db.collection("recipes").document(recipeId).getDocument { (doc, err) in
            if err != nil { return }
            if let document = doc, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.recipe = Recipe(document: document)
                self.getRecipeImage()
                self.loadUI()
                self.loadRatings()
                
            } else {
                print("Document does not exist")
            }
        }
        
    }
    func getRecipeImage(){
        let storageRef = st.reference()
        let imgRef = storageRef.child("recipeimages/\(recipeId!)/main.png")
        imgRef.getData(maxSize: 20 * 1024 * 1024) { (data, err) in
            if err != nil {
                print("error getting image", err!.localizedDescription)
                return }
            self.recipe?.mainImage = UIImage(data: data!)
            self.mainImage.image = self.recipe?.mainImage
        }
    }
    func loadUI(){
        self.mainImage.image = recipe?.mainImage
        self.recipeTitle.text = recipe?.title
        self.recipeDescr.text = recipe?.description
        self.recipeDifficulty.text = recipe?.difficulty.description
        self.cosmosView.settings.fillMode = .half
        self.cosmosView.rating = self.initialRating
        self.loadRatings()
    }
    func loadRatings(){
        db.collection("stars").whereField("recipeId", isEqualTo: recipe!.recipe_id).getDocuments { (snapshot, err) in
            if err != nil { return }
            self.ratings = [Double]()
            for doc in snapshot!.documents {
                self.ratings!.append(doc.data()["rating"] as! Double)
            }
            print("ratings count", self.ratings!.count)
            if self.ratings!.count != 0 {
            self.cosmosView.rating = self.ratings?.average ?? 2.5
            self.recipeRating.text = "Current rating: \(self.cosmosView.rating)/5"
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension Collection where Element: Numeric {
    /// Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(total) / Double(count)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    /// Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}
