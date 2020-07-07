//
//  AppDelegate.swift
//  rahulIosTask
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

   //MARK: - App Lifecycle

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         // Override point for customization after application launch.
       window = UIWindow(frame:UIScreen.main.bounds)
       window?.rootViewController = UINavigationController(rootViewController: ListViewController())
       window?.makeKeyAndVisible()

         return true
     }


}

