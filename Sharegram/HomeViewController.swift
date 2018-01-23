//
//  HomeViewController.swift
//  Sharegram
//
//  Created by 박주영 on 2018. 1. 11..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    var posts = [Post]()
    @IBOutlet weak var hometableView: UITableView!
    @IBAction func LogOutBtn(_ sender: Any) {
      // print(Auth.auth().currentUser)
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch let logoutError{
            print(logoutError)
        }
      //  print(Auth.auth().currentUser)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//        self.present(LoginViewController, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    //loadPosts 기능이 메인 홈 게시글 불러오게되야할듯?
    //Photo URL도 따야 
    func loadPosts() {
        ref?.child("posts").observe(.childAdded) {(DataSnapshot: DataSnapshot) in
            if DataSnapshot.value is NSNull {
                print("null")
            } else {
                if let dic = DataSnapshot.value as? [String:Any]{
                    
                    let captionText = dic["caption"] as! String
                    let PhotoStrings = dic["PhotoString"] as! String
                    let post = Post(captionText: captionText, photoStrings: PhotoStrings)
                    self.posts.append(post)
                    print(self.posts)
                    self.hometableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hometableView.dataSource = self
        ref = Database.database().reference()
        loadPosts()
        print((Auth.auth().currentUser?.displayName)!)
//        var post = Post(captionText: "test", photoStrings:" stirng1")
//            print(post.caption)
//            print(post.photoString)
        // Do any additional setup after loading the view.
    }
  


}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hometableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
}
