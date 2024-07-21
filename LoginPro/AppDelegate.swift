//
//  AppDelegate.swift
//  LoginPro
//
//  Created by Abhishek on 21/07/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var mainNav : UINavigationController!
    var window: UIWindow?

    class func classInstance() -> AppDelegate
    {
        return (UIApplication.shared.delegate as! AppDelegate)
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        
        if Auth.auth().currentUser != nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: HomeVC.className)as! HomeVC
            AppDelegate.classInstance().mainNav = UINavigationController(rootViewController: vc)
            AppDelegate.classInstance().window?.rootViewController = AppDelegate.classInstance().mainNav
            AppDelegate.classInstance().window?.makeKeyAndVisible()
            AppDelegate.classInstance().mainNav.navigationBar.isHidden = true

        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LoginVC.className)as! LoginVC
            AppDelegate.classInstance().mainNav = UINavigationController(rootViewController: vc)
            AppDelegate.classInstance().window?.rootViewController = AppDelegate.classInstance().mainNav
            AppDelegate.classInstance().window?.makeKeyAndVisible()
            AppDelegate.classInstance().mainNav.navigationBar.isHidden = true
        }
        

        return true
    }

}

