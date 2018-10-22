//
//  LoginViewController.swift
//  Voice_Diary
//
//  Created by 27k on 28/09/2018.
//  Copyright © 2018 27k. All rights reserved.
//

import Firebase
import GoogleSignIn
import UIKit

class LoginViewController: UITableViewController , GIDSignInUIDelegate {
    
    @IBOutlet weak var userEmail: DesignableTextField!
    @IBOutlet weak var userPassword: DesignableTextField!
    @IBOutlet weak var signUp: SpringImageView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        print("sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) ")
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }
    }
    
    @IBAction func signInAction(_ sender: Any) {

//                GIDSignIn.sharedInstance().uiDelegate = self
//                GIDSignIn.sharedInstance().signIn()
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
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
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
