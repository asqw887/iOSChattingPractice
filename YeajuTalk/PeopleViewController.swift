//
//  MainViewController.swift
//  YeajuTalk
//
//  Created by 최예주 on 2021/11/24.
//

import UIKit
import SnapKit
import Firebase

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var array: [UserModel] = []
    var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (m) in
            m.top.equalTo(view)
            
            m.bottom.left.right.equalTo(view)
        }
        
        
        
        
        Database.database().reference().child("user").observe( .value, with: { (snapshot) in
            
//            self.array.removeAll() // 중복 제거
            for child in snapshot.children{
                
                let fchild = child as! DataSnapshot
                let userModel = UserModel()
                userModel.setValuesForKeys(fchild.value as! [String : Any])
                self.array.append(userModel)
                
            }
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            
        })
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for :indexPath)
        
        let imageview = UIImageView()
        cell.addSubview(imageview)
        
        imageview.snp.makeConstraints { (m) in
            
            m.centerY.equalTo(cell)
            m.left.equalTo(cell).offset(20)
            m.height.width.equalTo(50)
        }
        
//        URL(string: array[indexPath.row].profileImageUrl)
        URLSession.shared.dataTask(with: URL(string: array[indexPath.row].profileImageUrl!)!) { (data, response, err) in
            DispatchQueue.main.async {
                imageview.image = UIImage(data: data!)
                imageview.layer.cornerRadius = imageview.frame.size.width/2 // 둥글게
                imageview.clipsToBounds = true
            }
        }.resume()
        
        
        let label = UILabel()
        cell.addSubview(label)
        label.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(imageview.snp.right).offset(20)
        }
        label.text = array[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let view = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") else { return  }

        self.navigationController?.pushViewController(view, animated: true)
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
