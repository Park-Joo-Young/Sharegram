//
//  ListViewController.swift
//  Sharegram
//
//  Created by apple on 2018. 4. 30..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class ListViewController: UIViewController {

    @IBAction func Back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var navi: UINavigationBar!
    @IBOutlet var ListTable: UITableView!
    var List : [String] = []
    var ref : DatabaseReference?
    var UserKeyForPrepare : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(List)
        ref = Database.database().reference()
        navi.barTintColor = UIColor.white
        navi.tintColor = UIColor.black
        navi.topItem?.title = "팔로우 리스트"
        navi.titleTextAttributes = [NSAttributedStringKey.font : UIFont(name: "BM DoHyeon OTF", size : 17)!]
        
        navi.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        ListTable.snp.makeConstraints { (make) in
            make.top.equalTo(navi.snp.bottom)
            make.width.equalTo(CommonVariable.screenWidth)
            make.height.equalTo(CommonVariable.screenHeight)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.centerX.equalTo(self.view)
        }
        ListTable.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "usercell")
        ListTable.rowHeight = 70
        ListTable.estimatedRowHeight = UITableViewAutomaticDimension
        ListTable.separatorStyle = .none
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! UserProFileViewController
        destination.UserKey = self.UserKeyForPrepare
    }
 

}
extension ListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ListTable.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserTableViewCell
        let str = self.List[indexPath.row]
        ref?.child("User").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let item = snapshot.value as? [String : AnyObject] {
                for(key, value) in item {
                        if key == str {
                            if let user = value["UserProfile"] as? [String : String]{
                                print("얘만 왜?")
                                if user["ProFileImage"] != nil {
                                    cell.profile.frame.size = CGSize(width: 50, height: 50)
                                    cell.profile.sd_setImage(with: URL(string: user["ProFileImage"]!), completed: nil)
                                    cell.profile.layer.borderWidth = 1.0
                                    cell.profile.layer.masksToBounds = false
                                    cell.profile.layer.cornerRadius = (cell.profile.frame.size.width) / 2.0
                                    cell.profile.layer.borderColor = UIColor.black.cgColor
                                    cell.profile.clipsToBounds = true
                                    cell.profile.contentMode = .scaleToFill
                                    print(user["사용자 명"]!)
                                    cell.name.text = user["사용자 명"]!
                                    cell.name.font = UIFont(name: "BM DoHyeon OTF", size : 15)!
                                    cell.followercount.text = ""
                                } else {
                                    cell.profile.frame.size = CGSize(width: 50, height: 50)
                                    cell.profile.image = UIImage(named: "profile.png")
                                    cell.profile.layer.borderWidth = 1.0
                                    cell.profile.layer.masksToBounds = false
                                    cell.profile.layer.cornerRadius = (cell.profile.frame.size.width) / 2.0
                                    cell.profile.layer.borderColor = UIColor.black.cgColor
                                    cell.profile.clipsToBounds = true
                                    cell.profile.contentMode = .scaleToFill
                                    cell.followercount.text = ""
                                    cell.name.text = user["사용자 명"]!
                                    cell.name.font = UIFont(name: "BM DoHyeon OTF", size : 15)!
                                }
                            }
                        }
                }
            }
        })
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.ListTable.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! UserTableViewCell
        
        self.UserKeyForPrepare(cell.name.text!)
        
    }
}
extension ListViewController {

    func UserKeyForPrepare(_ key1 : String) {
        print(key1)
        ref?.child("User").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let item = snapshot.value as? [String : AnyObject] {
                for(key,value) in item {
                    if let dic = value["UserProfile"] as? [String : String]{
                        print(dic)
                        if dic["사용자 명"] == key1 {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProFile") as! UserProFileViewController
                            vc.modalTransitionStyle = .crossDissolve
                            vc.UserKey = key
                            vc.UserName = key1
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
                
            }
            
        })
        ref?.removeAllObservers()
    }
    
}
