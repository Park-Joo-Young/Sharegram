//
//  HomeViewController.swift
//  Sharegram
//
//  Created by 박주영 on 2018. 1. 11..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UITableViewController {
    var ref: DatabaseReference?
    var handle: DatabaseHandle?
    var posts: [Post]?
    
    struct Storyboard {
        static let postCell = "PostCell"
        static let postHeaderCell = "PostHeaderCell"
        static let postHeaderHeight: CGFloat = 57.0
        static let postCellDefaultHeight: CGFloat = 578.0
    }
    func Activename()
    {
        
    }
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
//    func loadPosts() {
//        ref?.child("Posts").observe(.childAdded) {(DataSnapshot: DataSnapshot) in
//            if DataSnapshot.value is NSNull {
//                print("null")
//            } else {
//                if let dic = DataSnapshot.value as? [String:Any]{
//
//                    let captionText = dic["caption"] as! String
//                    let PhotoStrings = dic["PhotoString"] as! String
//                    let post = Post(captionText: captionText, photoString: PhotoStrings)
//                    self.posts.append(post)
//                    print(self.posts)
//                    self.hometableView.reloadData()
//                }
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ref = Database.database().reference()
//        loadPosts()
        print((Auth.auth().currentUser?.displayName)!)
        
        self.fetchPosts()
        
        tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
    }
    func fetchPosts()
    {
//        self.posts = Post.fetchPosts()
        self.tableView.reloadData()
    }


}
extension HomeViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = posts {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postCell, for: indexPath) as! PostCell
        
        cell.post = self.posts?[indexPath.section]
        //cell.postCaptionLabel.handleMentionTap(<#T##handler: (String) -> ()##(String) -> ()#>)
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postHeaderCell) as! PostHeaderCell
        
        cell.post = self.posts?[section]
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.postHeaderHeight
    }
    
  
    
}
//extension HomeViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
//        return posts.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = hometableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
//        cell.textLabel?.text = posts[indexPath.row].caption
//        return cell
//    }
//}

