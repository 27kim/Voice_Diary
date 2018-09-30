//
//  AddImageViewController.swift
//  Perdia
//
//  Created by Rawand Ahmed Shaswar on 10/19/17.
//  Copyright © 2017 DesertCoders Asia. All rights reserved.
//

import UIKit
import Photos
import Firebase
//import FirebaseDatabase

class AddImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var PTitle = ""
    var PDesc = ""
    var PDL = ""
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var PostImage: DesignableImageView!
    @IBOutlet var goButton: UIButton!
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Title \(PTitle) and Desc \(PDesc)" )
        imagePicker.delegate = self
        
        self.PostImage.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action:
                #selector(DidTapAdd(_:))
            )
        )
    }
    @objc func DidTapAdd(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.indicator.startAnimating()
        self.goButton.alpha = 0.5
        self.goButton.isEnabled = false
        self.PostImage.alpha = 0.5
        self.PostImage.isUserInteractionEnabled = false
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            PostImage.contentMode = .scaleAspectFit
            let storage = Storage.storage()
            
            // Create a storage reference from our storage service
            let storageRef = storage.reference()
            let data = pickedImage.jpegData(compressionQuality: 0.9)
            //            let  data = UIImageJPEGRepresentation(pickedImage, 1)
            let randomName = randomStringWithLength(len: 15)
            // Create a reference to the file you want to upload
            let riversRef = storageRef.child("images/\(randomName).jpg")
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    self.PostImage.animation = "shake"
                    self.PostImage.duration = 1
                    self.PostImage.animate()
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                //metadata.storageReference?.downloadURL(completion: <#T##(URL?, Error?) -> Void#>)
                // You can also access to download URL after upload.
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        print("ERROR guard let downloadURL = url else {")
                        return
                    }
                    
                    // print("Download image \(String(describing: downloadURL))")
                    let dl = String(describing:  downloadURL)
                    self.PDL = dl
                    print(dl)
                    
                    self.PostImage.contentMode = .scaleToFill
                    self.PostImage.image = pickedImage
                    
                    self.indicator.stopAnimating()
                    self.goButton.alpha = 1
                    self.PostImage.alpha = 1
                    self.PostImage.isUserInteractionEnabled = true
                    self.goButton.isEnabled = true
                }
            }
            
            dismiss(animated: true, completion: nil)
            
        }
    }
    //    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        self.indicator.startAnimating()
    //        self.goButton.alpha = 0.5
    //        self.goButton.isEnabled = false
    //        self.PostImage.alpha = 0.5
    //        self.PostImage.isUserInteractionEnabled = false
    //
    //        if let pickedImage = info[.originalImage] as? UIImage {
    //            PostImage.contentMode = .scaleAspectFit
    //            let storage = Storage.storage()
    //
    //
    //            // Create a storage reference from our storage service
    //            let storageRef = storage.reference()
    //            let  data = pickedImage.jpegData(compressionQuality: 1)
    //            //            let data = UIImage.jpegData(pickedImage)
    //            let randomName = randomStringWithLength(len: 15)
    //            // Create a reference to the file you want to upload
    //            let riversRef = storageRef.child("images/\(randomName).jpg")
    //
    //            // Upload the file to the path "images/rivers.jpg"
    //            let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in
    //                guard let metadata = metadata else {
    //                    // Uh-oh, an error occurred!
    //                    print("let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in")
    //                    self.PostImage.animation = "shake"
    //                    self.PostImage.duration = 1
    //                    self.PostImage.animate()
    //                    return
    //                }
    //                // Metadata contains file metadata such as size, content-type.
    //                let size = metadata.size
    //                // You can also access to download URL after upload.
    //                storageRef.downloadURL { (url, error) in
    //                    guard let downloadURL = url else {
    //                        // Uh-oh, an error occurred!
    //                        print("ERROR guard let downloadURL = url else {")
    //                        return
    //                    }
    //
    //                    let dl = String(describing: url!)
    //                    self.PDL = dl
    //                    print(dl)
    //
    //
    //                    self.PostImage.contentMode = .scaleToFill
    //                    self.PostImage.image = pickedImage
    //
    //                    self.indicator.stopAnimating()
    //                    self.goButton.alpha = 1
    //                    self.PostImage.alpha = 1
    //                    self.PostImage.isUserInteractionEnabled = true
    //                    self.goButton.isEnabled = true
    //                }
    //
    //            }
    //
    //            // Upload the file to the path "images/rivers.jpg"
    //            //            _ = riversRef.putData((data)!, metadata: nil) { (metadata, error) in
    //            //                guard let metadata = metadata else {
    //            //                    // Uh-oh, an error occurred!
    //            //                    self.PostImage.animation = "shake"
    //            //                    self.PostImage.duration = 1
    //            //                    self.PostImage.animate()
    //            //                    return
    //            //                }
    //            //
    //            //
    //            //
    //            //                let downloadURL = metadata.downloadURL()
    //            //               // print("Download image \(String(describing: downloadURL))")
    //            //                let dl = String(describing: downloadURL!)
    //            //                self.PDL = dl
    //            //                print(dl)
    //            //
    //            //
    //            //                self.PostImage.contentMode = .scaleToFill
    //            //                self.PostImage.image = pickedImage
    //            //
    //            //                self.indicator.stopAnimating()
    //            //                self.goButton.alpha = 1
    //            //                self.PostImage.alpha = 1
    //            //                self.PostImage.isUserInteractionEnabled = true
    //            //                self.goButton.isEnabled = true
    //            //
    //            //            }
    //
    //        }
    //
    //        dismiss(animated: true, completion: nil)
    //    }
    
    
    
    @IBAction func GoButton(_ sender: Any) {
        if (PDL.isEmpty == true) {
            self.PDL = "https://firebasestorage.googleapis.com/v0/b/itranslate-156516.appspot.com/o/christopher-campbell-322961.jpg?alt=media&token=cc0ebb2b-e68c-4a0e-842d-757b8649f1cd"
        } else {
            
        }
        self.SaveToFirebase(downloadURL: PDL, Title: self.PTitle, Desc: self.PDesc)
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    func SaveToFirebase(downloadURL: String,Title:String,Desc:String) {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE, MMMM dd, yyyy, h:mm:ss"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date as Date)//"Sunday"
        var ref: DatabaseReference!
        let user = Auth.auth().currentUser
        ref = Database.database().reference()
        let post:[String : Any] = [
            "Title":Title,
            "Desc":Desc,
            "Picture": downloadURL,
            "Date": dayInWeek,
            "isFav":"false",
            ]
        ref.child("Data").child(user!.uid).child("Data").childByAutoId().setValue(post)
        
        
    }
}
