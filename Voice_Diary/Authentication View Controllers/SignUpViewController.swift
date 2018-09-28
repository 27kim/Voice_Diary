//
//  SignUpViewController.swift
//  Voice_Diary
//
//  Created by 27k on 29/09/2018.
//  Copyright © 2018 27k. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UITableViewController {
    
    @IBOutlet weak var userName: DesignableTextField!
    @IBOutlet weak var userEmail: DesignableTextField!
    @IBOutlet weak var userPassword: DesignableTextField!
    
    @IBAction func signUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!) { (user, error) in
            // [START_EXCLUDE]
            
            if let error = error {
                
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
                        self.userPassword.animation = "shake"
                        self.userPassword.duration = 1.3
                        self.userPassword.animate()
                        
                    case .userNotFound:
                        self.userEmail.animation = "shake"
                        self.userEmail.duration = 1.3
                        self.userEmail.animate()
                        self.userPassword.animation = "shake"
                        self.userPassword.duration = 1.3
                        self.userPassword.animate()
                        
                        
                    default:
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
            }
            let userDef = UserDefaults.standard
            userDef.set(user?.user.email, forKey: "email")
            userDef.set(self.userPassword.text, forKey: "password")
            var tureFalse = Bool()
            tureFalse = true
            userDef.set(tureFalse, forKey: "isAutoLogin")
            userDef.synchronize()
            
            var ref: DatabaseReference!
            self.performSegue(withIdentifier: "cp", sender: self)
            ref = Database.database().reference()
            
            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat  = "EEEE, MMMM dd, yyyy, h:mm:ss" //"EE" to get short style
            let dayInWeek = dateFormatter.string(from: date as Date) //"Sunday"
            
            let post:[String : Any] = [
                "Title":"Welcome to Perdia",
                "Desc":"Big step... Also make sure to add your first diary by tapping the plus button on the bottom of your screen",
                "Picture":"https://firebasestorage.googleapis.com/v0/b/itranslate-156516.appspot.com/o/cathryn-lavery-67852.jpg?alt=media&token=6fdf0447-b990-44c2-99e7-de7daddef0e1",
                "Date": dayInWeek,
                "isFav":"true",
                
                
                ]
            
            
            ref.child("Data").child(user!.user.uid).setValue(["Username": self.userName.text])
            ref.child("Data").child(user!.user.uid).child("Data").childByAutoId().setValue(post)
            
            
            
            // [END_EXCLUDE]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
}
