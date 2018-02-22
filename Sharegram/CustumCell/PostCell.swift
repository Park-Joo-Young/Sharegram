//
//  PostCell.swift
//  Sharegram
//
//  Created by 박주영 on 2018. 1. 23..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var numberOfLikesButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
//    @IBOutlet weak var postCaptionLabel: UILabel!
 let postCaptionLabel = ActiveLabel()
    
    var storageref : StorageReference?
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
//        self.postImageView.image = post.image
        storageref = Storage.storage().reference().child(post.image!)
        storageref?.getData(maxSize: 30*1024*1024, completion: { (data, error) in
            if error == nil {
                print("제발")
                print(data!)
                let userphoto = UIImage(data: data!)
                self.postImageView.image = userphoto
                
            } else{
                print(error!.localizedDescription)
            }
        })
        postCaptionLabel.frame = CGRect(x: 12, y: 473, width: 351, height: 36)
        postCaptionLabel.font = UIFont.systemFont(ofSize: 15)
        postCaptionLabel.numberOfLines = 1
        postCaptionLabel.enabledTypes = [.mention, .hashtag, .url]
        postCaptionLabel.text = post.caption
       
        numberOfLikesButton.setTitle("Be the first one to share a comment", for: [])
        timeAgoLabel.text = post.timeAgo
    }
}

