//
//  HomeViewController.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//

import UIKit
import RxSwift
import RxRealm
import Realm
import RealmSwift

class HomeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    
    var settingContentList = ["Profile","Logout","Reset Password"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row == 0){
            if let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController{
                navigationController?.pushViewController(controller, animated: true)
            }
            
        }else if(indexPath.row == 1){
            let controller = UIAlertController(title: "Confirm Logout?", message: "All Data that stored in local will be removed and will not be Recovered.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
//                self.logout()

            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
            
        }else if(indexPath.row == 2){
            let controller = UIAlertController(title: "Confirm Reset Password?", message: "All data that stored in local will be removed and will not be Recovered.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { [self](_) in
                if let controller = storyboard?.instantiateViewController(withIdentifier: "ResetPwViewController") as? ResetPwViewController{
                    navigationController?.pushViewController(controller, animated: true)
                }
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.settingContentList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cellIdentifier = "SettingTableViewCell"
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingTableViewCell else {
        fatalError("The dequeued cell is not an instance of SettingTableViewCell.")
      }
        cell.settingLabel.text = self.settingContentList[indexPath.row]
        return cell
    }
}
