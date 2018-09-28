//
//  DetailViewController.swift
//  Voice_Diary
//
//  Created by 27k on 28/09/2018.
//  Copyright © 2018 27k. All rights reserved.
//

import UIKit


struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
//            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

class DetailViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
    var imageToImageView = ""
    var Title = ""
    var Description = ""
    var Dateblbl = ""
    var RefKey = String()
    var IsFav = Bool()
    
    
    @IBOutlet weak var DiaryImageView: DesignableImageView!
    @IBOutlet weak var DiaryLabel: UITextField!
    @IBOutlet weak var DiaryTextView: UITextView!
    @IBOutlet weak var closeImageView: SpringImageView!
    
    
    @IBOutlet weak var ShareImageView: SpringImageView!
    @IBOutlet weak var FavoriteImageView: SpringImageView!
    @IBOutlet weak var DeleteImageView: SpringImageView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet var view1: DesignableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadReq()
        print("output : \(RefKey)")
        
        
        self.DiaryLabel.text = Title
        self.DiaryTextView.text = Description
        let url = URL(string: imageToImageView)
//        self.DiaryImageView.sd_setImage(with: url! as URL)
         //self.DiaryImageView = UIImage(named: imageToImageView)
        self.DateLabel.text = Dateblbl
        
        AppUtility.lockOrientation(.portrait)
        
        self.closeImageView.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action:
                #selector(didTapImageview(_:))
            )
        )
        
        
        self.closeImageView.isUserInteractionEnabled = true
        
        
        ////
        
        
        self.FavoriteImageView.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action:
                #selector(DidTapFavorite(_:))
            )
        )
        
        
        self.DeleteImageView.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action:
                #selector(DidTapDelete(_:))
            )
        )
        self.DeleteImageView.isUserInteractionEnabled = true
        
        
        self.ShareImageView.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action:
                #selector(DidTapShare(_:))
            )
        )
        self.ShareImageView.isUserInteractionEnabled = true
    }
    
    @objc func didTapImageview(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        // do something
    }
    
    @objc func DidTapFavor(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toFav", sender: self)
        
        
    }
    @objc func DidTapSetting(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toSetting", sender: self)
        
        
    }
    @objc func DidTapAdd(_ sender: Any) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objSecond = storyboard.instantiateViewController(withIdentifier: "toAdd") as! AddRecordTableViewController
        self.navigationController?.pushViewController(objSecond, animated: true)
        
        
    }
    @objc func DidTapFavorite(_ sender: Any) {
//
//        if favoriteImageView.image == #imageLiteral(resourceName: "HeartTapped") {
//            var ref: DatabaseReference!
//            ref = Database.database().reference()
//            let userID = Auth.auth().currentUser?.uid
//            ref.child("Data/\(String(describing: userID!))/Data/\(RefKey)/isFav").setValue("false")
//            // ref.child("Data").child(userID!).child("Data").child(RefKey).setValue(["isFav": "false"])
//            self.favoriteImageView.image = #imageLiteral(resourceName: "HeartICon")
//            favoriteImageView.animation = "fadeIn"
//            favoriteImageView.duration = 1
//            favoriteImageView.animate()
//        } else {
//            favoriteImageView.animation = "fadeIn"
//            favoriteImageView.duration = 1
//            favoriteImageView.animate()
//            var ref: DatabaseReference!
//            ref = Database.database().reference()
//            let userID = Auth.auth().currentUser?.uid
//            ref.child("Data/\(String(describing: userID!))/Data/\(RefKey)/isFav").setValue("true")
//            //ref.child("Data").child(userID!).child("Data").child(RefKey).setValue(["isFav": "true"])
//            self.favoriteImageView.image = #imageLiteral(resourceName: "HeartTapped")
//        }
        
    }
    @objc func DidTapDelete(_ sender: Any) {
//
//        let alert = UIAlertController(title: "Are you sure?", message: "this action cannot be undone, means there's no going back!", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { action in
//            var ref: DatabaseReference!
//
//            ref = Database.database().reference()
//
//            let userID = Auth.auth().currentUser?.uid
//
//            ref.child("Data").child(userID!).child("Data").child(self.RefKey).removeValue()
//            self.dismiss(animated: true, completion: {
//                self.view1.animation = "zoomOut"
//                self.view1.duration = 2
//                self.view1.animate()
//            })
//
//
//
//        })
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
//            // perhaps use action.title here
//            alert.dismiss(animated: true, completion: nil)
//
//        })
//
//        self.present(alert, animated: true, completion: nil)
//
        
    }
    
    @objc func DidTapShare(_ sender: Any) {
        
//
//
//        // text to share
//        let text = Title
//        let desc = Description
//
//        // set up activity view controller
//        let textToShare = [ text,desc ]
//        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.mail,UIActivityType.message,UIActivityType.postToTwitter ]
//
//        // present the view controller
//        self.present(activityViewController, animated: true, completion: nil)
//
//
        
    }
}
