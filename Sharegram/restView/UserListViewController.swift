//
//  UserListViewController.swift
//  Sharegram
//
//  Created by apple on 2018. 5. 7..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import SnapKit
import Firebase


class UserListViewController: UIViewController {

    @IBOutlet var UserList: UITableView!
    var name : String = ""
    var List : [[String : String]] = []
    var delegate : GetUserName!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("씨부레 이것이 나다!!\(name)")
        UserList.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(CommonVariable.screenWidth)
            make.height.equalTo(CommonVariable.screenHeight)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        UserList.separatorStyle = .none
        UserList.separatorInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        UserList.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "usercell")
        print(List)
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
extension UserListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserTableViewCell
        cell.tag = indexPath.row
        let dic = self.List[indexPath.row]
        if dic["ProFileImage"] != nil {
            cell.profile.frame.size = CGSize(width: 50, height: 50)
            cell.profile.sd_setImage(with: URL(string: dic["ProFileImage"]!), completed: nil)
            cell.profile.layer.borderWidth = 1.0
            cell.profile.layer.masksToBounds = false
            cell.profile.layer.cornerRadius = (cell.profile.frame.size.width) / 2.0
            cell.profile.layer.borderColor = UIColor.black.cgColor
            cell.profile.clipsToBounds = true
            cell.profile.contentMode = .scaleToFill
            
        } else { //이미지가 없다ㅋ
            cell.profile.frame.size = CGSize(width: 50, height: 50)
            cell.profile.image = UIImage(named: "profile.png")
            cell.profile.layer.borderWidth = 1.0
            cell.profile.layer.masksToBounds = false
            cell.profile.layer.cornerRadius = (cell.profile.frame.size.width) / 2.0
            cell.profile.layer.borderColor = UIColor.black.cgColor
            cell.profile.clipsToBounds = true
            cell.profile.contentMode = .scaleToFill
        }
        cell.name.text = dic["사용자 명"]
        cell.name.font = UIFont(name: "BM DoHyeon OTF", size : 15)!
        cell.followercount.text = ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.UserList.cellForRow(at: indexPath) as! UserTableViewCell
        self.delegate.getName(cell.name.text!)
        self.List.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
}
