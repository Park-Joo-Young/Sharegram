//
//  ActivityViewController.swift
//  Sharegram
//
//  Created by 박주영 on 2018. 1. 11..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import Firebase

class ActivityViewController: UIViewController {
   
    @IBOutlet weak var activitytable: UITableView!
    let segment = ScrollableSegmentedControl()
    var Following: [String] = [] //팔로잉 소식
    var MyLog: [String] = [] //내 활동 로그
    var ref: DatabaseReference?
    var keyList: [String] = []
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        self.view.addSubview(segment)
        segment.segmentStyle = .textOnly
        segment.insertSegment(withTitle: "팔로잉", at: 0)
        segment.insertSegment(withTitle: "내 소식", at: 1)
        segment.underlineSelected = true
        segment.addTarget(self, action: #selector(ActSegClicked), for: .valueChanged)
        segment.segmentContentColor = UIColor.black
        segment.selectedSegmentContentColor = UIColor.black
        segment.backgroundColor = UIColor.white
        segment.selectedSegmentIndex = 0
        
        let largerRedTextHighlightAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.blue]
        let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.orange]
        segment.setTitleTextAttributes(largerRedTextHighlightAttributes, for: .highlighted)
        segment.setTitleTextAttributes(largerRedTextSelectAttributes, for: .selected)

        let SwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SwipeLeftAction))
        SwipeLeft.direction = .left
        //activitytable.addGestureRecognizer(SwipeLeft)
        let SwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SwipeRightAction))
        SwipeRight.direction = .right

    }
    func SearchFollowing() {
        for i in 0..<self.keyList.count {
            ref?.child("User").child(self.keyList[i]).child("UserProfile").observe(.value, with: { (snapshot) in
                if snapshot.value is NSNull {
                    print("null")
                } else {
                    if let item = snapshot.value as? [String : String] {
                        self.Following.append(item["사용자 명"]!)
                        self.activitytable.reloadData()
                    }
                }
            })
        }
    }
    @objc func SwipeLeftAction() {
        segment.selectedSegmentIndex += 1
    }
    @objc func SwipeRightAction() {
        segment.selectedSegmentIndex -= 1
    }
    @objc func ActSegClicked(_ sender : ScrollableSegmentedControl) {
        if segment.selectedSegmentIndex == 1 { // 팔로잉
            print("1")
            self.Following.removeAll()
            self.keyList.removeAll()
           
            ref?.child("User").observe(.value, with: { (snapshot) in
                if snapshot.value is NSNull {
                    print("Nothing")
                } else {
                    for child in snapshot.children {
                        let user = child as! DataSnapshot
                        self.keyList.append(user.key)
                    }
                    if self.keyList.count == Int(snapshot.childrenCount) {
                        print("??")
                        print(self.keyList.count)
                        self.SearchFollowing()
                    }
                }
            })
        } else if segment.selectedSegmentIndex == 2 { // 내 소식
            print("1")
           
            self.Following.removeAll()

            self.activitytable.reloadData()
            ref?.child("HashTagPosts").observe(.childAdded, with: { (snapshot) in
                if snapshot.value is NSNull {
                    print("null")
                } else {
                    self.MyLog.append("#" + snapshot.key)
                }
            })
        } else {
        
            self.Following.removeAll()
            self.activitytable.reloadData()
            return
          
        }
    }


 
    

    
}
