//
//  ChatViewController.swift
//  YeajuTalk
//
//  Created by 최예주 on 2021/12/03.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    
    public var destinationUid :String? // 나중에 내가 채팅할 대상의 UID
    
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc
    func createRoom(){
        
        let createRoomInfo = [
            "uid":Auth.auth().currentUser?.uid,
            "destinationUid":destinationUid
        ]
        
        Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo)
        
        
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
