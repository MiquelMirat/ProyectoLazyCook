//
//  ResultsViewController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 22/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultsCollection: UICollectionView!

    var resultRecipes:[Recipe]?
    var async_queue:DispatchQueue?
    var selectedRecipe:Recipe?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsCollection.delegate = self
        resultsCollection.dataSource = self
        self.navigationItem.title = "LazyCook"
        getRecipeImages()
        async_queue = DispatchQueue(label: "images")
        print("result count: ", self.resultRecipes!.count)
        // Do any additional setup after loading the view.
    }
    
    func getRecipeImages(){
        let storage_ref = Storage.storage().reference()
        
        for r in resultRecipes! {
            let image_ref = storage_ref.child("recipeimages/\(r.recipe_id)").child("main.png")
            image_ref.getData(maxSize: 20 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("ERROROROROROR", error.localizedDescription)
                }else{
                    print("SUCCESSSSSS")
                    self.async_queue!.async(execute: {
                        r.mainImage = UIImage(data: data!)
                        
                    })
                    
                }
            }
        }
        resultsCollection.reloadData()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipeDetailVC{
            let vc = segue.destination as? RecipeDetailVC
            vc?.recipeId = self.selectedRecipe!.recipe_id
            
        }
        
    }
 

}

extension ResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultRecipes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as? RecipeCell
        cell?.mainImage.image = resultRecipes?[indexPath.row].mainImage
        cell?.titleLbl.text = resultRecipes?[indexPath.row].title
        cell?.descrLbl.text = resultRecipes?[indexPath.row].description
        cell?.difficultyLbl.text = "Difficulty Level: " + resultRecipes![indexPath.row].difficulty.description
        cell?.timeLbl.text = "Cooking time: " + String(resultRecipes![indexPath.row].cooking_time)
        cell?.cookLbl.text = "Cook: " + resultRecipes![indexPath.row].cook_id
        return cell!
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedRecipe = self.resultRecipes![indexPath.row]
        self.performSegue(withIdentifier: "resultToRecipeDetail", sender: self)
    }
    
    
    
    
    
}
