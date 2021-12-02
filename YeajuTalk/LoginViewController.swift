//
//  LoginViewController.swift
//  YeajuTalk
//
//  Created by 최예주 on 2021/11/23.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    // 색 리모트로 가져올거임
    let remoteconfig = RemoteConfig.remoteConfig()
    
    var color: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 파이어베이스는 자동 로그인 이므로 강제 로그아웃
        try! Auth.auth().signOut()
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        
        color = remoteconfig["splash_background"].stringValue
        statusBar.backgroundColor = UIColor(hex: color)
        loginButton.backgroundColor = UIColor(hex: color)
        signInButton.backgroundColor = UIColor(hex: color)
        
        loginButton.addTarget(self, action: #selector(loginEvnet), for: .touchUpInside)
        
        
        
        signInButton.addTarget(self, action: #selector(presentSignup), for: .touchUpInside)
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil) {
                print("-->clicked login")
                let view = self.storyboard?.instantiateViewController(withIdentifier: "MainViewTabBarController") as! UITabBarController
                
                self.present(view, animated: true, completion: nil)
                
            }
        }
    }
    
    
    @objc func presentSignup(){
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.present(view, animated: true, completion: nil)
    }
    
    
    @objc
    func loginEvnet(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, err) in
            
            if(err != nil){
                let alert = UIAlertController(title: "에러", message: err.debugDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
