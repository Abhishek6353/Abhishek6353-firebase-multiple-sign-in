//
//  HomeVC.swift
//  LoginPro
//
//  Created by Abhishek on 21/07/24.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = Auth.auth().currentUser?.displayName {
            nameLabel.text = name
        }
        
    }
    
    
    @IBAction func didTapLogotButton(_ sender: UIButton) {
        Utility.showLoadingView()
        do {
            try Auth.auth().signOut()
            Utility.hideLoadingView()
            guard let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LoginVC.className) as? LoginVC else {
                return
            }
            AppDelegate.classInstance().mainNav = UINavigationController(rootViewController: loginVC)
            AppDelegate.classInstance().window?.rootViewController = AppDelegate.classInstance().mainNav
            AppDelegate.classInstance().mainNav.topViewController?.view.makeToast(ToastMessages.logoutSuccess)
            AppDelegate.classInstance().mainNav.navigationBar.isHidden = true
            
        } catch let error as NSError {
            Utility.hideLoadingView()
            print(error.localizedDescription)
        }
    }
    
}
