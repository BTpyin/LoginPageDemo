//
//  ProfileViewController.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//

import UIKit
import RxSwift
import RxRealm
import Realm
import RealmSwift

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel?
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var memIdTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileViewModel()
//        uiBind(member: (viewModel?.member?.first)!)
        uiBind(member: Member().demoMember())
        // Do any additional setup after loading the view.
    }
    
    func uiBind(member: Member){
        profileView.roundCorners(cornerRadius: 25)
        profileView.layer.applySketchShadow(
          color: .black,
          alpha: 0.4,
          x: 0,
            y: 0.5,
          blur: 6,
            spread: 0)

        nameTextField.roundCorners(cornerRadius: 10)
        memIdTextField.roundCorners(cornerRadius: 10)
        emailTextField.roundCorners(cornerRadius: 10)
        phoneTextField.roundCorners(cornerRadius: 10)

        nameTextField.text = member.memberName
        memIdTextField.text = member.memberNumber
        emailTextField.text = member.email
        phoneTextField.text = member.phone
        
        
        
        
        
    }

}
class ProfileViewModel{
    var member: Results<Member>?
    init(){
        member = try? Realm().objects(Member.self)
    }
}
