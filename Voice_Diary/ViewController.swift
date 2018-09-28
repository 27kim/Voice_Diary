//
//  ViewController.swift
//  Voice_Diary
//
//  Created by 27k on 23/09/2018.
//  Copyright © 2018 27k. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet weak var MyCollectionView: UICollectionView!
    @IBOutlet weak var goToFav: UIImageView!
    @IBOutlet weak var toAdd: UIImageView!
    @IBOutlet weak var setting: UIImageView!
    
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellCollectionViewCell
        
        cell.TitleLabel.text = "드디어 성공했다 개빸개빸"
        cell.Desc.text = "망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 망할 놈의 Xcode 드디어 성공했네 아오 빸쳐 개빸 더럽게 복잡하네 아놔 진짜 "
        cell.PosterImageView.image = UIImage(named: "testbg")
        //cell.PosterImageView.sd_setImage(with: url! as URL)

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
//        controller.imageToImageView = DataLoadedFromFirebase[indexPath.row].Image
//        controller.Title = DataLoadedFromFirebase[indexPath.row].Title
//        controller.Description = DataLoadedFromFirebase[indexPath.row].Desc
//        controller.RefKey = DataLoadedFromFirebase[indexPath.row].RefKey
//        controller.Dateblbl = DataLoadedFromFirebase[indexPath.row].Date
    }

}

