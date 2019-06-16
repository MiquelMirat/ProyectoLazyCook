//
//  SettingsController.swift
//  SideMenuTutorial
//
//  Created by Stephen Dowless on 2/23/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingsController: UIViewController {
    
    // MARK: - Properties
    
    var username: String?
    let userDefaults = UserDefaults()
    let manager = Manager.shared
    let db = Firestore.firestore()
    let st_ref = Storage.storage().reference()
    //var signOut : UIButton?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        let button = UIButton(frame: CGRect(x: 30, y: 150, width: 100, height: 50))
        button.backgroundColor = .gray
        button.setTitle("Sign out", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        if let username = username {
            print("Username is \(username)")
        } else {
            print("Username not found..")
        }
       
    }
    @objc func buttonAction(sender: UIButton!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
            manager.manageSignOutSuccess()
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.present(nextViewController, animated:true, completion:nil)
            
            
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    // MARK: - Selectors
    
    
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        //view.addSubview(signOut!)
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_clear_white_36pt_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
    
        
    
}

