//
//  UserTableViewCell.swift
//  Sharegram
//
//  Created by apple on 2018. 4. 30..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import SnapKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet var profile: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var followercount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profile.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        name.snp.makeConstraints { (make) in
            make.centerY.equalTo(profile)
            make.width.equalTo(self.frame.width/4)
            make.height.equalTo(self.frame.height/2)
            make.left.equalTo(profile.snp.right).offset(10)
        }
        followercount.snp.makeConstraints { (make) in
            make.centerY.equalTo(profile)
            make.size.equalTo(name)
            make.right.equalTo(self.snp.right).offset(-10)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
