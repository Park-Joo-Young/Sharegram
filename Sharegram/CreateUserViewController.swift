//
//  CreateUserViewController.swift
//  Sharegram
//
//  Created by apple on 2018. 1. 10..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class CreateUserViewController: UIViewController {
    //var Object = variable()
    var CreateUser = UIButton()
    var EmailText = UITextField()
    var PasswordText = UITextField()
    var DisplayName = UITextField()
    var Cancel = UIButton()
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let su = self.view!
        su.addSubview(EmailText)
        su.addSubview(PasswordText)
        su.addSubview(DisplayName)
        su.addSubview(CreateUser)
        su.addSubview(Cancel)
        
        EmailText.snp.makeConstraints({ (make) in
            make.width.equalTo(su.frame.width/2)
            make.height.equalTo(su.frame.height/20)
            make.centerX.equalTo(su)
            make.top.equalTo(su).offset(100)
        })
        PasswordText.snp.makeConstraints({ (make) in
            make.size.equalTo(EmailText)
            make.centerX.equalTo(EmailText)
            make.top.equalTo(EmailText.snp.bottom).offset(30)
        })
        DisplayName.snp.makeConstraints { (make) in
            make.size.equalTo(EmailText)
            make.centerX.equalTo(EmailText)
            make.top.equalTo(PasswordText.snp.bottom).offset(30)
        }
        
        EmailText.borderStyle = .roundedRect
        PasswordText.borderStyle = .roundedRect
        DisplayName.borderStyle = .roundedRect
        
        EmailText.placeholder = "이메일을 입력하시오."
        PasswordText.placeholder = "비밀번호를 입력하시오."
        DisplayName.placeholder = "사용자 명을 입력하시오."
        
        EmailText.autocapitalizationType = .none
        EmailText.autocorrectionType = .no
        
        PasswordText.autocapitalizationType = .none
        PasswordText.isSecureTextEntry = true
        PasswordText.autocorrectionType = .no
        

        //DisplayName.autocorrectionType = .no
        
        CreateUser.snp.makeConstraints { (make) in
            make.width.equalTo(su.frame.width/2)
            make.height.equalTo(su.frame.height/30)
            make.centerX.equalTo(su)
            make.top.equalTo(DisplayName.snp.bottom).offset(30)
        }
        Cancel.snp.makeConstraints { (make) in
            make.size.equalTo(CreateUser)
            make.centerX.equalTo(su)
            make.top.equalTo(CreateUser.snp.bottom).offset(30)
        }
        
        CreateUser.backgroundColor = UIColor.black
        CreateUser.setTitle("Login", for: .normal)
        CreateUser.tintColor = UIColor.white
        CreateUser.addTarget(self, action: #selector(ActCreateUser), for: .touchUpInside)
        
        Cancel.backgroundColor = UIColor.black
        Cancel.setTitle("Cancel", for: .normal)
        Cancel.tintColor = UIColor.white
        Cancel.addTarget(self, action: #selector(ActCancel), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func ActCreateUser(sender : UIButton) {
        if EmailText.text! != "" && PasswordText.text! != "" && DisplayName.text! != "" {
            Auth.auth().createUser(withEmail: EmailText.text!, password: PasswordText.text!, completion: { (user, error) in
                if user != nil {
                    print("Create Success")
                    //user!.createProfileChangeRequest()
                    let data = ["이메일" : self.EmailText.text!]
                    let data1 = ["사용자 명" : self.DisplayName.text!]
                    self.ref?.child("User").child(user!.uid).child("UserProfile").setValue(data)
                    self.ref?.child("User").child(user!.uid).child("UserProfile").updateChildValues(data1)
                    let user = Auth.auth().currentUser!
                    let changeRequest = user.createProfileChangeRequest()
                        
                    changeRequest.displayName = self.DisplayName.text!
                    changeRequest.commitChanges { error in
                        if let error = error {
                                // An error happened.
                                print(error)
                        } else {
                                // Profile updated.
                            self.displayMessage(title: "회원가입을 축하합니다.", message: " ")
                            }
                        }
                    
                    
                } else {
                    if let myError = error?.localizedDescription {
                        print(myError)
                    } else {
                        print("error")
                    }
                }
            })
        } else {
            self.displayErrorMessage(title: "공백이 있습니다.", message: "데이터를 입력해주세요")
        }
    }
    func displayErrorMessage(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) {
            (action : UIAlertAction) -> Void in
        }
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    func displayMessage(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) {
            (action : UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    @objc func ActCancel(sender : UIButton) {
        dismiss(animated: true, completion: nil)
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
