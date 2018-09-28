//
//  AddRecordTableViewController.swift
//  Perdia
//
//  Created by Rawand Ahmed Shaswar on 10/19/17.
//  Copyright © 2017 DesertCoders Asia. All rights reserved.
//

import UIKit
//import FirebaseDatabase
//import FirebaseAuth
import Firebase

class AddRecordTableViewController: UITableViewController,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet var DescTextView: UITextView!
    @IBOutlet var TitleTextField: UITextField!
 

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {

       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    @IBAction func PassThem(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objSecond = storyboard.instantiateViewController(withIdentifier: "vc2") as! AddImageViewController
        objSecond.PTitle = TitleTextField.text!
        objSecond.PDesc = DescTextView.text
        self.navigationController?.pushViewController(objSecond, animated: true)
        
        
    }
}
