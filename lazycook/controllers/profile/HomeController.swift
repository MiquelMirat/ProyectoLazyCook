

import UIKit
import Firebase

private let reuseIdentifier = "ProfileOptionCell"

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: HomeControllerDelegate?
    let storage = Storage.storage()
    var db = Firestore.firestore()
    var data:Data?
    var tableView: UITableView!
    var headerView: UIView!
    var collectionView: UICollectionView!
    var image : UIImage?
    var imageView : UIImageView?
    //var image = snakeRef
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        //configureTableView()
        configureNavigationBar()
        
        
        
    }
    
    // MARK: - Handlers
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }
}



