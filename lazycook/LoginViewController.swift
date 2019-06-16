//
//  LoginViewController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 22/03/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController,GIDSignInUIDelegate {
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    
    let userDefaults = UserDefaults()
    var actualUser:User?
    var manager:Manager?
    var signIn:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        manager = Manager.shared
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefaults.bool(forKey: "usersignedin") {
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    
    @IBAction func handleControlTabbed(_ sender: Any) {
        signIn = !signIn
        if signIn {
            submitBtn.setTitle("Sign In", for: .normal)
            titleLbl.text = "Sign In"
        }else{
            submitBtn.setTitle("Sign Up", for: .normal)
            titleLbl.text = "Register"
        }
        
        
    }
    @IBAction func handleSignInBtn(_ sender: Any) {
        let mail = txtMail.text ?? ""
        let pass = txtPass.text ?? ""
        
        if mail != "" && pass != "" {
            if signIn {
                //LOG IN
                Auth.auth().signIn(withEmail: mail, password: pass) { (result, error) in
                    if error == nil {
                        //Si la authenticacion a sido correcta se llama a este metodo que guarda el usuario y la sesion y lo devuelve a esta vista
                        self.actualUser = self.manager?.manageAuthSuccess(result: result)
                        if self.actualUser != nil {
                            self.performSegue(withIdentifier: "loginToHome", sender: self)
                        }
                        
                    }else{
                        print(error!.localizedDescription)
                    }
                    
                }
                
            }else{
                //sign up
                Auth.auth().createUser(withEmail: mail, password: pass) { (result, error) in
                    if error == nil {
                        self.actualUser = self.manager?.manageAuthSuccess(result: result)
                        if self.actualUser != nil {
                            self.performSegue(withIdentifier: "loginToHome", sender: self)
                        }
                    }
                    
                }
                
            }
        }else{
            print("fill all fields")
            //TAL VEZ UNA VENTANITA EMERGENTE AVISANDO
        }
        
        
        
    }
    
    
    
    
    
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance().signOut()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    

}
