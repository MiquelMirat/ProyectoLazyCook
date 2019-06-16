//
//  FeedViewController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 25/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    @IBOutlet weak var feedTable: UITableView!
    
    var feed:[Feed]?
    var selectedFeed:Feed?
    let db = Firestore.firestore()
    let st = Storage.storage()
    let manager = Manager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadFeed()
        feedTable.delegate = self
        feedTable.dataSource = self
        feedTable.separatorStyle = .none
        self.navigationItem.title = "Feedback"


        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if feed == nil {
            loadFeed()
        }
    }
    func loadFeed(){
        print("loading feed")
        self.feed = [Feed]()
        db.collection("stars").whereField("cookId", isEqualTo: manager.actualUser?.id ?? "default").getDocuments { (snapshot, err) in
            if err != nil {
                return
            }
            for document in snapshot!.documents {
                let f = Feed(document: document)
                self.feed?.append(f)
            }
            self.feedTable.reloadData()
            self.loadFeedImages()
        }
        
    }
    func loadFeedImages(){
        print("loading feed images: feed count:", String(feed!.count))
        let storage_ref = st.reference()
        for f in self.feed! {
            let image_ref = storage_ref.child("recipeimages/\(f.recipeId)").child("main.png")
            image_ref.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("ERROROROROROR", error.localizedDescription)
                }else{
                    print("SUCCES getting image for feed")
                    f.thumbnail = UIImage(data: data!)
                    self.feedTable.reloadData()
                }
            }
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare from feed")
        if segue.destination is RecipeDetailVC{
            let vc = segue.destination as? RecipeDetailVC
            vc?.recipeId = self.selectedFeed?.recipeId
            
        }
    }
 

}
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTable.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        let text:String = (self.feed![indexPath.row].senderDisplayName + " has rated your recipe ")
        cell.feedDecription.text = text
        cell.feedImage.image = self.feed![indexPath.row].thumbnail
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFeed = self.feed?[indexPath.row]
        if selectedFeed != nil {
            self.performSegue(withIdentifier: "feedToRecipeDetail", sender: self)
        }
    }
    
}
