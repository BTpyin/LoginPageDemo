//
//  RootNavigationController.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//

import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let controller = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController{
            controller.modalPresentationStyle = .fullScreen
            controller.hideNavigationBarShadow = true
            pushViewController(controller, animated: true)
        }
        // Do any additional setup after loading the view.
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
