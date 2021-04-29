//
//  LoginViewController.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//


import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var disposeBag = DisposeBag()
    var viewModel : LoginViewModel
    
    


    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var sidTextField: UITextField!
    @IBOutlet weak var loginBackgroundView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginBottomLineView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func configureUI(){
        sidTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        sidTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        emailTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        emailTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        passwordTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        passwordTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)

        self.loginButton.setTitleColor(UIColor.init(red: 255, green: 189, blue: 43), for: .normal)
        self.loginButton.setTitleColor(UIColor.init(red: 128, green: 128, blue: 128), for: .disabled)
        self.loginBottomLineView.backgroundColor = UIColor.init(red: 128, green: 128, blue: 128)
    }
    
}

class LoginViewModel{
    var memIDInput = BehaviorRelay<String?>(value: nil)
    var emailInput = BehaviorRelay<String?>(value: nil)
    var passwordInput = BehaviorRelay<String?>(value: nil)
    var loginEnable = BehaviorRelay<Bool>(value: false)
    
    func enableCheck(){
        if(memIDInput.value != "" && memIDInput.value?.count == 8 && emailInput.value != "" && passwordInput.value != ""){
            loginEnable.accept(true)
        }
        else{
            loginEnable.accept(false)
        }
    }
}
