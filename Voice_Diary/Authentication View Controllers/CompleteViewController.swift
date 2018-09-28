//
//  CompleteViewController.swift
//  Voice_Diary
//
//  Created by 27k on 29/09/2018.
//  Copyright © 2018 27k. All rights reserved.
//

import UIKit
import Firebase

class CompleteViewController: UIViewController {
    
    @IBOutlet weak var licenseImage: DesignableImageView!
    
    @IBAction func letsGo(_ sender: Any) {
        let userDef = UserDefaults.standard
        let email = userDef.string(forKey: "email")!
        let password = userDef.string(forKey: "password")!
        userDef.synchronize()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // [START_EXCLUDE]
            
            if let error = error {
                print("eroror \(error.localizedDescription)")
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as! LoginViewController
                
                self.present(controller, animated: false, completion: nil)
                
                return
            } else {
                self.performSegue(withIdentifier: "slogin", sender: self)
                print("Loged in")
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.licenseImage.animation = "zoomIn"
        self.licenseImage.duration = 1
        self.licenseImage.animate()
        
        
    }
}
