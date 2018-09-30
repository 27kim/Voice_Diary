//
//  ViewController.swift
//  Voice_Diary
//
//  Created by 27k on 23/09/2018.
//  Copyright © 2018 27k. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

struct LoadFromFirebase {
    let Image : String
    let Title : String
    let Desc : String
    let Date : String
    let RefKey : String
}

class ViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet weak var MyCollectionView: UICollectionView!
    @IBOutlet weak var goToFav: UIImageView!
    @IBOutlet weak var toAdd: UIImageView!
    @IBOutlet weak var setting: UIImageView!
    
    var DataLoadedFromFirebase = [LoadFromFirebase]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //이 부분이 빠지면 바인딩이 안되서 데이터가 안나옴
        MyCollectionView.dataSource = self
        MyCollectionView.delegate = self
        
        self.goToFav.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action:
                #selector(DidTapFavor(_:))
            )
        )
        self.goToFav.isUserInteractionEnabled = true
        
        self.setting.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action:
                #selector(DidTapSetting(_:))
            )
        )
        self.setting.isUserInteractionEnabled = true
        self.toAdd.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action:
                #selector(DidTapAdd(_:))
            )
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataLoadedFromFirebase.removeAll()
        loadData()
        // Dispose of any resources that can be recreated.
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

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellCollectionViewCell
//
//        cell.TitleLabel.text = "드디어 성공했다 개빸개빸"
//        cell.Desc.text = "망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 "
//        cell.PosterImageView.image = UIImage(named: "testbg")
//        //cell.PosterImageView.sd_setImage(with: url! as URL)
//
//        cell.layer.cornerRadius = 4.5 // optional
//        // Shadow and Radius
//        cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
//        cell.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
//        cell.layer.shadowOpacity = 1.5
//        cell.layer.shadowRadius = 0.0
//        cell.layer.masksToBounds = true
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let controller = storyboard?.instantiateViewController(withIdentifier: "secondVC") as! DetailViewController
////        controller.imageToImageView = DataLoadedFromFirebase[indexPath.row].Image
//        controller.Title = "드디어 성공했다 개빸개빸"
//        controller.Description = "망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 "
//        controller.RefKey = "RefKey?"
//        controller.Dateblbl = "2018-09-28"
//
//        self.present(controller, animated: false, completion: nil)
//    }
    
    func loadData() {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("Data").child(userID!).child("Data").observe(.childAdded, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let title = value?["Title"] as? String ?? "Unknown"
            let image = value?["Picture"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/itranslate-156516.appspot.com/o/cathryn-lavery-67852.jpg?alt=media&token=6fdf0447-b990-44c2-99e7-de7daddef0e1"
            let desc = value?["Desc"] as? String ?? "Error"
            let Date = value?["Date"] as? String ?? "Error"
            let RefKey = snapshot.key
            print("Current Ref Key \(RefKey)")
            self.DataLoadedFromFirebase.insert(LoadFromFirebase(Image:image ,Title: title , Desc: desc, Date: Date ,RefKey: RefKey) , at: 0)
            self.MyCollectionView.reloadData()
            
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //Firebase DB 사용
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataLoadedFromFirebase.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellCollectionViewCell
        cell.TitleLabel.text = DataLoadedFromFirebase[indexPath.row].Title
        cell.Desc.text = DataLoadedFromFirebase[indexPath.row].Desc

        let url = URL(string: DataLoadedFromFirebase[indexPath.row].Image)
        cell.PosterImageView.sd_setImage(with: url! as URL)


        cell.layer.cornerRadius = 4.5 // optional
        // Shadow and Radius
        cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        cell.layer.shadowOpacity = 1.5
        cell.layer.shadowRadius = 0.0
        cell.layer.masksToBounds = true


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


        let controller = storyboard?.instantiateViewController(withIdentifier: "secondVC") as! DetailViewController
        controller.imageToImageView = DataLoadedFromFirebase[indexPath.row].Image
        controller.Title = DataLoadedFromFirebase[indexPath.row].Title
        controller.Description = DataLoadedFromFirebase[indexPath.row].Desc
        controller.RefKey = DataLoadedFromFirebase[indexPath.row].RefKey
        controller.Dateblbl = DataLoadedFromFirebase[indexPath.row].Date
        self.present(controller, animated: false, completion: nil)


    }
    
}

