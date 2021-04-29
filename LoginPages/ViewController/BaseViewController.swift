//
//  ViewController.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//

import UIKit

class BaseViewController: UIViewController {

    var clearColorNavigationBar: Bool = false
    var hideNavigationBarShadow: Bool = false
    
    
    // Store a navBar reference for un-doing navBar style change after navigationController == nil
    weak var modifiedNavigationBar: UINavigationBar?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    func startLoading() {
      loadingIndicator?.startAnimating()
      loadingIndicator?.isHidden = false
    }

    func stopLoading() {
      loadingIndicator?.isHidden = true
    }

    func isLoading() -> Bool {
      return !(loadingIndicator?.isHidden ?? true)
    }
    
    func showErrorAlert(reason: SyncDataFailReason? = nil,
                        showCache: Bool = false,
                        okClicked: ((UIAlertAction) -> Void)? = nil) {
        if reason == .other ||
        reason == .realmWrite ||
        reason == nil {
        showAlert("Error",
                  okClicked: okClicked)
      }
    }

    
    func showAlert(_ title: String?, okClicked: ((UIAlertAction) -> Void)? = nil) {
      let alertVC = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction.init(title: "OK", style: .default, handler: okClicked))
      present(alertVC, animated: true, completion: nil)
    }

}

