//
//  ResetPwViewController.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//

import UIKit
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift
import FirebaseAuth
import Firebase

class ResetPwViewController: BaseViewController, UITextFieldDelegate {
    
    var disposeBag = DisposeBag()
    var viewModel: ResetPwViewModel?
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    @IBOutlet weak var buttonLine: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ResetPwViewModel()
        passwordTextField.delegate = self
        reEnterTextField.delegate = self

        self.navigationItem.title = "Reset Password"
        configureUI()
        
        passwordTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.passwordInput.accept( self.passwordTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        reEnterTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.reInputPassword.accept( self.reEnterTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)

        viewModel?.resetEnable.asObservable().subscribe(onNext: { (_) in
            self.resetButton.isEnabled = (self.viewModel?.resetEnable.value)!
            if (!(self.resetButton.isEnabled)){
//                self.signInButton.titleLabel?.textColor = UIColor.init(red: 128, green: 128, blue: 128)
                self.buttonBackgroundView.backgroundColor = UIColor.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.2)
                self.buttonLine.backgroundColor = UIColor.init(red: 128, green: 128, blue: 128)
            }else{

//                self.signInButton.titleLabel?.textColor = UIColor.init(red: 255, green: 189, blue: 43)
                self.buttonLine.backgroundColor = UIColor.systemOrange
                self.buttonBackgroundView.backgroundColor = UIColor.init(red: 255/255, green: 189/255, blue: 43/255, alpha: 0.1)
            }
          }).disposed(by: disposeBag)
    }
    
    func configureUI(){

        passwordTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        passwordTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        reEnterTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        reEnterTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        self.resetButton.setTitleColor(UIColor.init(red: 255, green: 189, blue: 43), for: .normal)
        self.resetButton.setTitleColor(UIColor.init(red: 128, green: 128, blue: 128), for: .disabled)
        self.buttonLine.backgroundColor = UIColor.init(red: 128, green: 128, blue: 128)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        resetPw()
    }
    
    func resetPw(){
        var autherror = true
        Auth.auth().currentUser?.updatePassword(to: (viewModel?.passwordInput.value)!){ error in
            if error == nil {
                
                autherror = false
                
                
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let saveAction = UIAlertAction(title: "Save Password", style: .default){
                    action in
                    UserDefaults.standard.set((self.viewModel?.passwordInput.value)!, forKey:"password")
                    self.navigationController?.popToRootViewController(animated: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initial = storyboard.instantiateInitialViewController()
                        UIApplication.shared.keyWindow?.rootViewController = initial

                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                    action in
                    UserDefaults.standard.set("", forKey:"password")
                    self.navigationController?.popToRootViewController(animated: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initial = storyboard.instantiateInitialViewController()
                        UIApplication.shared.keyWindow?.rootViewController = initial

                }
                actionSheet.addAction(saveAction)
                actionSheet.addAction(cancelAction)
                self.present(actionSheet, animated:true, completion: nil)
            }else {
                self.showAlert(error?.localizedDescription)
                autherror = true
            }
        }
        Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!){error in
            if error == nil {
                autherror = false
            }else {
                self.showAlert(error?.localizedDescription)
                autherror = true
            }
        }

//            do {
//                try Auth.auth().signOut()
//            }
//                 catch let signOutError as NSError {
//                        print ("Error signing out: %@", signOutError)
//            }
        
 
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case passwordTextField: reEnterTextField.becomeFirstResponder()
        case reEnterTextField: reEnterTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

class ResetPwViewModel{
    var passwordInput = BehaviorRelay<String?>(value: nil)
    var reInputPassword = BehaviorRelay<String?>(value: nil)
    var resetEnable = BehaviorRelay<Bool>(value: false)
    
    func enableCheck(){
        if(passwordInput.value != "" && reInputPassword.value != "" &&  passwordInput.value == reInputPassword.value ){
            resetEnable.accept(true)
        }
        else{
            resetEnable.accept(false)
        }
    }
}
