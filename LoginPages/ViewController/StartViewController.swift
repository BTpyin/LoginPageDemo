//
//  StartViewController.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//

import UIKit

class StartViewController: BaseViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController{
            navigationController?.pushViewController(controller, animated: true)
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
