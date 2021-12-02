//
//  ViewController.swift
//  YeajuTalk
//
//  Created by 최예주 on 2021/11/22.
//

import UIKit
import SnapKit
import Firebase

class ViewController: UIViewController {
    
    var box = UIImageView()
    var remoteConfig : RemoteConfig!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        
        // 서버랑 연결이 안될때 이 디폴트값을 씀
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        
        remoteConfig.fetch { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.remoteConfig.activate { changed, error in
              // ...
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
            
          self.displayWelcome()
        }
        
        
        // Do any additional setup after loading the view.
        self.view.addSubview(box)
        
        box.snp.makeConstraints { (make) in
            make.center.equalTo(self.view) // 센터로 가게
            
        }
        
        box.image = #imageLiteral(resourceName: "loading_icon")
        
        
    }
    
    func displayWelcome(){
        
        let color = remoteConfig["splash_background"].stringValue
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
        
        
        // cap이 True면 앱이 원격으로 꺼지게
        if(caps){
            let alert =  UIAlertController(title: "공지사항", message: message , preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default  ,   handler:  { (action) in
                exit(0)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        // 실행
        else{
            
            
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            self.present(loginVC, animated: false, completion: nil)
            
            
            
        }
        
        self.view.backgroundColor = UIColor(hex: color!)
    }


}


// hex 코드 변환 
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
