//
//  LoginViewController.swift
//  Sharegram
//
//  Created by apple on 2018. 1. 10..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class LoginViewController: UIViewController {
    //var Object = variable()
    var EmailText = UITextField()
    var PasswordText = UITextField()
    var LoginBut = UIButton()
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        EmailText.text = ""
        PasswordText.text = ""
        let su = self.view!
        su.addSubview(EmailText)
        su.addSubview(PasswordText)
        su.addSubview(LoginBut)
        
        segment.snp.makeConstraints { (make) in
            make.width.equalTo(su.frame.width/2)
            make.height.equalTo(su.frame.height/25)
            make.centerX.equalTo(su)
            make.top.equalTo(su).offset(100)
        }
        EmailText.snp.makeConstraints({ (make) in
            make.width.equalTo(su.frame.width/1.5)
            make.height.equalTo(su.frame.height/20)
            make.centerX.equalTo(su)
            make.top.equalTo(segment.snp.bottom).offset(30)
        })
        PasswordText.snp.makeConstraints({ (make) in
            make.size.equalTo(EmailText)
            make.centerX.equalTo(EmailText)
            make.top.equalTo(EmailText.snp.bottom).offset(30)
        })
        
        EmailText.borderStyle = .roundedRect
        EmailText.autocapitalizationType = .none
        EmailText.autocorrectionType = .no
        EmailText.placeholder = "이메일을 입력하시오."
        
        PasswordText.borderStyle = .roundedRect
        PasswordText.autocapitalizationType = .none
        PasswordText.isSecureTextEntry = true
        PasswordText.autocorrectionType = .no
        PasswordText.placeholder = "비밀번호를 입력하시오."
        
        LoginBut.snp.makeConstraints { (make) in
            make.width.equalTo(su.frame.width/2)
            make.height.equalTo(su.frame.height/30)
            make.centerX.equalTo(su)
            make.top.equalTo(PasswordText.snp.bottom).offset(30)
        }
        LoginBut.backgroundColor = UIColor.black
        LoginBut.setTitle("Login", for: .normal)
        LoginBut.tintColor = UIColor.white
        LoginBut.addTarget(self, action: #selector(ActLogin), for: .touchUpInside)
        // Do any additional setup after loading the view.
       
            
    }
        override func viewDidAppear(_ animated: Bool){
            super.viewDidAppear(animated)
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
            
        }
    @objc func ActLogin(sender : UIButton) {
        if segment.selectedSegmentIndex == 0 {
            if EmailText.text! != "" && PasswordText.text! != "" { //공백이 아닐 때
                Auth.auth().signIn(withEmail: EmailText.text!, password: PasswordText.text!, completion: { (user, error) in
                    if user != nil {
                        print("Success")
                        self.performSegue(withIdentifier: "Login", sender: self)
                    } else {
                        if let myError = error?.localizedDescription {
                            print(myError)
                        } else {
                            print("error")
                        }
                    }
                })
            } else {
                self.displayErrorMessage(title: "공백입니다.", message: "데이터를 입력해주세요.")
            }
        }
    }
    @IBAction func ActSeg(_ sender: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            print("Login Tap")
        }
        else if segment.selectedSegmentIndex == 1 { //Create User
            performSegue(withIdentifier: "Create", sender: self)
        }
        else {
            print("fuck")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
