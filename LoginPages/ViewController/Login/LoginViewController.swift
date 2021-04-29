//
//  LoginViewController.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//


import UIKit
import RxSwift
import RxRealm
import Realm
import RealmSwift
import RxCocoa

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var disposeBag = DisposeBag()
    var viewModel : LoginViewModel?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var memberIdTextField: UITextField!
    @IBOutlet weak var loginBackgroundView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginBottomLineView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        configureUI()

        
        memberIdTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.memIDInput.accept(self.memberIdTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        
        emailTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.emailInput.accept(self.emailTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.passwordInput.accept(self.passwordTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        viewModel?.loginEnable.asObservable().subscribe(onNext: { (_) in
            self.loginButton.isEnabled = (self.viewModel?.loginEnable.value)!
            if (!(self.loginButton.isEnabled)){
//                self.signInButton.titleLabel?.textColor = UIColor.init(red: 128, green: 128, blue: 128)
                self.loginBackgroundView.backgroundColor = UIColor.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.2)
                self.loginBottomLineView.backgroundColor = UIColor.init(red: 128, green: 128, blue: 128)
            }else{

//                self.signInButton.titleLabel?.textColor = UIColor.init(red: 255, green: 189, blue: 43)
                self.loginBottomLineView.backgroundColor = UIColor.systemOrange
                self.loginBackgroundView.backgroundColor = UIColor.init(red: 255/255, green: 189/255, blue: 43/255, alpha: 0.1)
            }
          }).disposed(by: disposeBag)
    }
    
    func configureUI(){
        memberIdTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        memberIdTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        emailTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        emailTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        passwordTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        passwordTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)

        self.loginButton.setTitleColor(UIColor.init(red: 255, green: 189, blue: 43), for: .normal)
        self.loginButton.setTitleColor(UIColor.init(red: 128, green: 128, blue: 128), for: .disabled)
        self.loginBottomLineView.backgroundColor = UIColor.init(red: 128, green: 128, blue: 128)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case memberIdTextField : emailTextField.becomeFirstResponder()
            break
        case emailTextField : passwordTextField.becomeFirstResponder()
        case passwordTextField: passwordTextField.resignFirstResponder()

        default:
            break
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
