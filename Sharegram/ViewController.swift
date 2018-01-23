//
//  ViewController.swift
//  Sharegram
//
//  Created by 박주영 on 2018. 1. 9..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    var image : String!
    var storageRef : StorageReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(image)
        storageRef = Storage.storage().reference().child(image)
        storageRef?.getData(maxSize: 30*1024*1024, completion: { (data, error) in
            if error == nil {
                print("제발")
                print(data!)
                let userphoto = UIImage(data: data!)
                self.imageview.image = userphoto
               
            } else{
                 print(error!.localizedDescription)
            }
        })
//        storageRef?.child(image).downloadURL(completion: { (url, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//            } else {
//                print("여긴")
//
//                let userphoto = UIImage(data: data)
//                self.imageview.image = userphoto
//            }
//        })
        
        //dqw
        //내가 작업
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

