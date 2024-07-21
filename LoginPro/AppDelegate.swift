//
//  AppDelegate.swift
//  LoginPro
//
//  Created by Abhishek on 21/07/24.
//

import UIKit

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
        return true
    }

}

