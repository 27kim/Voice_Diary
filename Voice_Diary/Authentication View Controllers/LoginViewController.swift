//
//  LoginViewController.swift
//  Voice_Diary
//
//  Created by 27k on 28/09/2018.
//  Copyright © 2018 27k. All rights reserved.
//

import Firebase
import UIKit

class LoginViewController: UITableViewController {
    
    @IBOutlet weak var userEmail: DesignableTextField!
    @IBOutlet weak var userPassword: DesignableTextField!
    @IBOutlet weak var signUp: SpringImageView!
    
    @IBAction func signInAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: userEmail.text!, password: userPassword.text!) { (user, error) in
            // [START_EXCLUDE]
            
            if let error = error {
                print("eroror \(error.localizedDescription)")
                
                
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    
                    switch errCode {
                    case .invalidEmail:
                        print("invalid email")
                        
                        self.userEmail.animation = "shake"
                        self.userEmail.duration = 1.3
                        self.userEmail.animate()
                        
                    case .emailAlreadyInUse:
                        print("in use")
                        
                        self.userEmail.animation = "shake"
                        self.userEmail.duration = 1.3
                        self.userEmail.animate()
                    case .wrongPassword:
                        print("wrongPassword")
                        self.userPassword.animation = "shake"
                        self.userPassword.duration = 1.3
                        self.userPassword.animate()
                        
                    case .userNotFound:
                        print("userNotFound")
                        self.userEmail.animation = "shake"
                        self.userEmail.duration = 1.3
                        self.userEmail.animate()
                        self.userPassword.animation = "shake"
                        self.userPassword.duration = 1.3
                        self.userPassword.animate()
                        
                        
                    default:
                        print("in use")
                        self.userEmail.animation = "shake"
                        self.userEmail.duration = 1.3
                        self.userEmail.animate()
                        self.userPassword.animation = "shake"
                        self.userPassword.duration = 1.3
                        self.userPassword.animate()
                        print("Create User Error: \(error)")
                    }
                }
                return
            } else {
                let userDef = UserDefaults.standard
                var tureFalse = Bool()
                tureFalse = true
                userDef.set(tureFalse, forKey: "isAutoLogin")
//                userDef.set(user?.user.email, forKey: "email")
                userDef.set(self.userPassword.text, forKey: "password")
                userDef.synchronize()
                self.performSegue(withIdentifier: "slogin", sender: self)
                print("Loged in")
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUp.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action:
                #selector(didTapSignUp(_:))
            )
        )
        self.signUp.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didTapSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signup", sender: self)
    }

    
}
