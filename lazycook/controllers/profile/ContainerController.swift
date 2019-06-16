

import UIKit
import Firebase
//import GoogleSignIn

class ContainerController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var recipeImage: UIImageView!
    // MARK: - Properties
    var homeController:HomeController!
    var menuController: MenuController!
    //var profileViewCell: ProfileViewCell!
    var centerController: UIViewController!
    var isExpanded = false
    var delegate: HomeControllerDelegate?
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var resultRecipes:[Recipe]?
    var recipes:[Recipe]?
    var followersCount:Int?
    var data:Data?
    var user = Auth.auth().currentUser!.uid
    var mine:[String]?
    var selectedRecipe:Recipe?
    var async_queue:DispatchQueue?
    var result:[Recipe]?
    let userDefaults = UserDefaults()
    let manager = Manager.shared
    let st_ref = Storage.storage().reference()
    var hasPickedImage:Bool = true {
        didSet{
            
        }
    }
    @IBOutlet weak var buttonUpload: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var recipeCollection: UICollectionView!
    @IBOutlet weak var labelFollowers: UILabel!
    
    @IBOutlet weak var labelNameFollowers: UILabel!
    //@IBOutlet weak var titleBackground: UIImageView!
    // MARK: - Init
    
    
    //@IBOutlet weak var recipeCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
        self.recipeCollection.delegate = self
        self.recipeCollection.dataSource = self
        downloadImage(name: user)
        getFollowings()
        fetchRecipes()
        //labelFollowers.text = self.mine?.count
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    // MARK: - Handlers
    
    func configureHomeController() {
        self.homeController = HomeController()
        homeController.delegate = self
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        centerController = UINavigationController(rootViewController: homeController)
        homeController.view.addSubview(labelFollowers)
        homeController.view.addSubview(labelNameFollowers)
        homeController.view.addSubview(profileImage)
        homeController.view.addSubview(buttonUpload)
        homeController.view.addSubview(recipeCollection)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
        
    }
    
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipeDetailVC{
            let vc = segue.destination as? RecipeDetailVC
            vc?.recipeId = self.selectedRecipe!.recipe_id
            vc?.recipe = self.selectedRecipe!
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        
        if shouldExpand {
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
            
        } else {
            // hide menu
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .Settings:
            let controller = SettingsController()
            controller.username = "Batman"
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func downloadImage(name:String){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let snakeRef = storageRef.child("profileimages/"+name+".jpg")
        snakeRef.getData(maxSize: 20 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("ERROROROROROR downloading", error.localizedDescription)
            }else{
                print("SUCCESSSSSS")
                self.profileImage.image = UIImage(data: data!)
                //image = UIImage(data: data!)
                /*self.imageView.image = UIImage(data: data!)*/
                //self.data = data!
                
                
            }
        }
        
    }
    func uploadImage(name:String, data:Data){
        let storageRef = storage.reference()
        let path:String = ("profileimages/"+name+".jpg")
        let riversRef = storageRef.child(path)
        riversRef.putData(data, metadata:nil){
            (metadata, error) in
            guard metadata != nil else{
                return
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

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
    func getFollowings(){
        if self.mine == nil { self.mine = [String]() }
        db.collection("recipes").whereField("cook_id", isEqualTo: self.user).getDocuments(completion: { (doc, err) in
            if err != nil { return }
            for u in doc!.documents {
                for f in u.data()["recipes"] as? Array ?? ["none"] {
                    self.mine?.append(f)
                }
            }
            print("mine count",self.mine!.count)
            self.fetchRecipes()
        })
    }
    
    func fetchRecipes(){
        self.recipes = [Recipe]()
        for (index, _) in self.mine!.enumerated() {
            
            db.collection("recipes").whereField("cook_id", isEqualTo: self.user).getDocuments { (snapshot, err) in
                if err != nil { return }
                for r in snapshot!.documents {
                    self.recipes?.append(Recipe(document: r))
                    print(self.recipes!.count)
                }
                if index == self.mine!.endIndex - 1{
                    print("mine v2", self.mine!.count)
                    self.recipeCollection.reloadData()
                    self.fetchRecipeImages()
                    self.fetchRecipeRatings()
                }
                
            }
        }
        
    }
    
    func fetchRecipeImages(){
        for (index, r) in self.recipes!.enumerated(){
            //print("recipescount", r.recipe_id)
            st_ref.child("recipeimages/\(r.recipe_id)/main.png")
                .getData(maxSize: 20 * 1024 * 1024) { (data, err) in
                    if err != nil {
                        //print("hola123")
                        return
                        
                    }
                    //print("recipescount 2222", r.recipe_id)
                    r.mainImage = UIImage(data: data!)
                    print("index: ", index)
                    self.recipeCollection.reloadData()
            }
        }
        print("recipes count v2",self.recipes!.count)
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
}



extension ContainerController :
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("done")
        if let image = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage{
            let data:Data = image.jpegData(compressionQuality: 1)!
            //var name:String = "test"
            uploadImage(name: Auth.auth().currentUser!.uid, data: data)
            profileImage.image = image
            hasPickedImage = true
        }else{
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerConrollerDidCancel(_ picker:
        UIImagePickerController){
        print("cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}

extension ContainerController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mine?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as? RecipeCell
        cell?.mainImage.image = recipes?[indexPath.row].mainImage
        cell?.titleLbl.text = recipes?[indexPath.row].title
        /*
         cell?.descrLbl.text = recipes?[indexPath.row].description
         cell?.difficultyLbl.text = "Difficulty Level: " + recipes![indexPath.row].difficulty.description
         cell?.timeLbl.text = "Cooking time: " + String(recipes![indexPath.row].cooking_time)
         cell?.cookLbl.text = "Cook: " + recipes![indexPath.row].cook_id*/
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     self.selectedRecipe = self.recipes![indexPath.row]
     self.performSegue(withIdentifier: "profileToRecipeDetail", sender: self)
     }
    
    
    
}
