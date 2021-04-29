//
//  RegisterViewController.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//

import UIKit
import RxSwift
import RxRealm
import RealmSwift
import RxCocoa
import FirebaseFirestore
import FirebaseAuth


class RegisterViewController: BaseViewController, UITextFieldDelegate {

    var db: Firestore!
    var disposeBag = DisposeBag()
    var viewModel : RegisterViewModel?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var memberIdTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    @IBOutlet weak var buttonLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegisterViewModel()
        memberIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        reEnterTextField.delegate = self
        db = Firestore.firestore()
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(scrollViewTap)
        configureUI()

        memberIdTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.memIdInput.accept(self.memberIdTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.emailInput.accept(self.emailTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.nameInput.accept(self.nameTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.phoneInput.accept(self.phoneTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.passwordInput.accept(self.passwordTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        reEnterTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [self]_ in
                viewModel?.reInputPassword.accept(self.reEnterTextField.text)
                viewModel?.enableCheck()
            })
            .disposed(by: disposeBag)
        
        
        viewModel?.signInEnable.asObservable().subscribe(onNext: { (_) in
            self.signInButton.isEnabled = (self.viewModel?.signInEnable.value)!
            if (!(self.signInButton.isEnabled)){
//                self.signInButton.titleLabel?.textColor = UIColor.init(red: 128, green: 128, blue: 128)
                self.buttonBackgroundView.backgroundColor = UIColor.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.2)
                self.buttonLine.backgroundColor = UIColor.init(red: 128, green: 128, blue: 128)
            }else{

//                self.signInButton.titleLabel?.textColor = UIColor.init(red: 255, green: 189, blue: 43)
                self.buttonLine.backgroundColor = UIColor.systemOrange
                self.buttonBackgroundView.backgroundColor = UIColor.init(red: 255/255, green: 189/255, blue: 43/255, alpha: 0.1)
            }
          }).disposed(by: disposeBag)
        

        
        // Do any additional setup after loading the view.
    }
    
    func configureUI(){
        memberIdTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        memberIdTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        emailTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        emailTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        nameTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        nameTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        phoneTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        phoneTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        passwordTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        passwordTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        reEnterTextField.textColor = UIColor.init(red: 96,green: 96,blue: 96)
        reEnterTextField.borderColor = UIColor.init(red: 168,green: 168,blue: 168)
        self.signInButton.setTitleColor(UIColor.init(red: 255, green: 189, blue: 43), for: .normal)
        self.signInButton.setTitleColor(UIColor.init(red: 128, green: 128, blue: 128), for: .disabled)
        self.buttonLine.backgroundColor = UIColor.init(red: 128, green: 128, blue: 128)
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {

        if(passwordTextField.text != reEnterTextField.text){
            self.showAlert("Please Re-Enter Password!")
        }
        
        viewModel?.memIdInput.accept(memberIdTextField.text)
        viewModel?.emailInput.accept(emailTextField.text)
        viewModel?.nameInput.accept(nameTextField.text)
        viewModel?.phoneInput.accept(phoneTextField.text)
        
        //create user
        Auth.auth().createUser(withEmail: (viewModel?.emailInput.value)!, password: (viewModel?.reInputPassword.value)!){ [self] (user, error) in
                    if error == nil {
                        self.navigationController?.popViewController(animated: true)
                        db.collection("users").addDocument(data: [
                            "memberName": viewModel?.nameInput.value!,
                            "memId": viewModel?.memIdInput.value!,
                            "email": viewModel?.emailInput.value!,
                            "phone": viewModel?.phoneInput.value!,
                            "uid": user?.user.uid
                        ]) { (error) in
                            if let error = error {
                                self.showAlert(error.localizedDescription)
                                print(error)
                            }
                        }

                    }
                    else{
                        self.showAlert(error?.localizedDescription)
                        print(error)
                    }

                }

        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case memberIdTextField : emailTextField.becomeFirstResponder()
            break
        case emailTextField : nameTextField.becomeFirstResponder()
        case nameTextField : phoneTextField.becomeFirstResponder()
        case phoneTextField : passwordTextField.becomeFirstResponder()
        case passwordTextField: reEnterTextField.becomeFirstResponder()
        case reEnterTextField: reEnterTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    @objc func scrollViewTapped() {
//        print("scrollViewTapped")
            view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}


class RegisterViewModel{
    var memIdInput = BehaviorRelay<String?>(value: nil)
    var passwordInput = BehaviorRelay<String?>(value: nil)
    var reInputPassword = BehaviorRelay<String?>(value: nil)
    var emailInput = BehaviorRelay<String?>(value: nil)
    var nameInput = BehaviorRelay<String?>(value: nil)
    var phoneInput = BehaviorRelay<String?>(value: nil)
    var signInEnable = BehaviorRelay<Bool>(value: false)
    
    func enableCheck(){
        if(memIdInput.value != "" && memIdInput.value?.count == 8 &&
            passwordInput.value != "" && reInputPassword.value != "" && passwordInput.value == reInputPassword.value &&
            emailInput.value != "" && nameInput.value != "" && phoneInput.value != ""){
            signInEnable.accept(true)
        }
        else{
            signInEnable.accept(false)
        }
    }
}
