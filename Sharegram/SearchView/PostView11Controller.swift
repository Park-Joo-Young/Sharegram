//
//  PostView11Controller.swift
//  Sharegram
//
//  Created by apple on 2018. 3. 12..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import SnapKit
import Koloda
import Firebase
class PostView11Controller: UIViewController {
    
    var PostView = KolodaView()
    var Posts = [Post]()
    var Id : String = ""
    var ProFileUrl : String = ""
    var ref : DatabaseReference?

    @IBOutlet weak var NextBut: UIButton!
    @IBOutlet weak var PreviousBut: UIButton!
    @IBOutlet weak var LikeCountLabel: UILabel!
    func fetchPost(){
        ref?.child("WholePosts").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? [String : String] {
                let post = Post()
                print(snapshot.childrenCount)
                if item["ID"] == self.Id { //전체 포스트에서 검색부분에서 가져온 유저아이디랑 일치하는 게시물을 찾았을 때
                    print("DDD")
                    if item["latitude"] == nil && item["longitude"] == nil { //위치가 없으면
                        post.caption = item["Description"]
                        post.Id = item["ID"]
                        post.image = item["image"]
                        post.lat = 0
                        post.lon = 0
                        post.numberOfLikes = item["Like"]
                        post.username = item["Author"]
                        post.PostId = item["postID"]
                        post.timeAgo = item["Date"]
                        self.Posts.append(post)
                        self.PostView.reloadData()
                    } else {
                        post.caption = item["Description"]
                        post.Id = item["ID"]
                        post.image = item["image"]
                        post.lat = Int(item["latitude"]!)
                        post.lon = Int(item["longitude"]!)
                        post.numberOfLikes = item["Like"]
                        post.username = item["Author"]
                        post.PostId = item["postID"]
                        post.timeAgo = item["Date"]
                        self.Posts.append(post)
                        self.PostView.reloadData()
                    }
                }
            }
        })
        ref?.removeAllObservers()
    }
    func fetchUser(_ id : String) {
        
        ref?.child("User").child(id).child("UserProfile").observe(.value, with: { (snapshot) in
            if let item = snapshot.value as? [String : String] {
                self.ProFileUrl = item["ProFileImage"]!
                self.PostView.reloadData()
            }
        })
    }
    @IBAction func Previous(_ sender: UIButton) {
        PostView.revertAction()
    }
    @IBAction func Next(_ sender: UIButton) {
        PostView.swipe(.right, force: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.Posts.removeAll()
        fetchUser(Id)
        fetchPost()
        print(Posts)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        self.view.addSubview(PostView)
        PostView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width / 1.3)
            make.height.equalTo(self.view.frame.height/1.5)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(100)
        }
        PostView.dataSource = self
        PostView.delegate = self
        NextBut.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.centerX).offset(30)
            make.top.equalTo(PostView.snp.bottom).offset(20)
        }
        PreviousBut.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.snp.centerX).offset(-30)
            make.top.equalTo(NextBut)
        }
        LikeCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(70)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        LikeCountLabel.adjustsFontSizeToFitWidth = true
        LikeCountLabel.textColor = UIColor.white
        let color = UIColor(red: 75/255, green: 76/255, blue: 76/255, alpha: 1)
        self.view.backgroundColor = color

//        PostView.layer.cornerRadius = PostView.frame.height / 3.0
//        PostView.layer.borderWidth = 2.0
//        PostView.layer.borderColor = UIColor.black.cgColor
//        PostView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PostView11Controller: KolodaViewDelegate, KolodaViewDataSource {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        return
    }
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return Posts.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let postview = Bundle.main.loadNibNamed("PostView", owner: self, options: nil)?.first as! PostView
        postview.layer.borderWidth = 1.0
        postview.layer.borderColor = UIColor.black.cgColor
        postview.layer.cornerRadius = postview.frame.height / 25.0
        postview.clipsToBounds = true
        postview.PostImage.sd_setImage(with: URL(string: Posts[index].image!), completed: nil)
        postview.ProFileImage.sd_setImage(with: URL(string: ProFileUrl), completed: nil)
        postview.Caption.text = Posts[index].caption!
        postview.Caption.numberOfLines = 0
        postview.Caption.enabledTypes = [.hashtag, .mention, .url]
        //postview.Caption.text = (Posts[indexPath.row].username)! + "   " + (Posts[indexPath.row].caption)!
        postview.Caption.textColor = UIColor.black
        postview.Caption.handleHashtagTap { (hashtag) in
            print("씨발ㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎ")
        }
        if Posts[index].numberOfLikes == "0" {
            LikeCountLabel.text = "마음에 드신다면 하트를 눌러주세요"
        } else {
            LikeCountLabel.text = "좋아요" + Posts[index].numberOfLikes! + "개"
        }
       
        //postview.LikeCountLabel.text = Posts[index].numberOfLikes!
        postview.UserName.text = Posts[index].username!
        postview.TimeLabel.text = "1시간 전"
        postview.TimeLabel.textColor = UIColor.lightGray
        return postview
    }
    
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
//    }
}