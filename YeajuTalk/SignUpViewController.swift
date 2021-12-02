//
//  SignUpViewController.swift
//  YeajuTalk
//
//  Created by 최예주 on 2021/11/23.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var cancleButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    let remoteconfig = RemoteConfig.remoteConfig()
    var color: String!
    let storage = Storage.storage()  // storage 인스턴스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar = UIView()
        
        
        // 이미지뷰에 피커 달기
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        
        
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        
        color = remoteconfig["splash_background"].stringValue
        statusBar.backgroundColor = UIColor(hex: color)
        
        signUpButton.backgroundColor = UIColor(hex: color)
        cancleButton.backgroundColor = UIColor(hex: color)
        
        
        signUpButton.addTarget(self, action: #selector(signUpEvent), for: .touchUpInside)
        
        cancleButton.addTarget(self, action: #selector(cancelevent), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    
    // 회원가입 이벤트
    @objc
    func signUpEvent(){
        Auth.auth().createUser(withEmail: emailTextField.text!, password: pwTextField.text!) { (user,err) in
            
            let uid = user?.user.uid
            
            let metaData = StorageMetadata()
            let image = self.imageView.image?.jpegData(compressionQuality: 0.1)
//
//            print("-->")
//            print(uid!)
            
            self.storage.reference().child("userImages").child(uid!).putData(image!, metadata: metaData) { (metaData, error) in if let error = error {
                print(error.localizedDescription)
                return
            }else{

                self.storage.reference().child("userImages").child(uid!).downloadURL(completion: { (url, err) in
                        print("성공!")
                    
                    Database.database().reference().child("user").child(uid!).setValue(["name":self.nameTextField.text,"profileImageUrl":url?.absoluteString,"uid":Auth.auth().currentUser?.uid]) { (err,ref) in
                        
                        if (err==nil){
                            self.cancelevent()
                        }
                    }
                })
                

            }

            }
//
            
                
//                let imageRef = Storage.storage().reference().child("userImages").child(uid)
//
//
//            imageRef.putData(image!, metadata: nil, completion: {(StorageMetadata, Error) in
//
//                imageRef.downloadURL(completion: { (url, err) in
//
//                    Database.database().reference().child("user").child(uid!).setValue(["name":self.nameTextField.text,"profileImageUrl":url?.absoluteString])
//
//                        })
//
//                    })
           
            
//
//
//            Database.database().reference().child("users").child(uid!).setValue(["profileImageUrl":self.nameTextField.text!]) // 데베에 이름 저장
//
//            Database.database().reference().child("users").child(uid!).setValue(["name":self.nameTextField.text!]) // 데베에 이름 저장
            
            }
    }
    
    @objc
    func cancelevent(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc
    func imagePicker(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
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
