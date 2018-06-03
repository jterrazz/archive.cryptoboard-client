//
//  AppDelegate.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 19/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = UIColor.white
        tabBarController.tabBar.isOpaque = true
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = UIColor.white
        tabBarController.tabBar.tintColor = UIColor.theme.elemFront.value
        tabBarController.tabBar.unselectedItemTintColor = UIColor.theme.elemBack.value

        let navigationController = UINavigationController(rootViewController: tabBarController)
        navigationController.view.backgroundColor = UIColor.clear
        
        // Setting all main controllers
        let iconInset = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        let homeController = HomeViewController()
        let homeIcon = UITabBarItem(title: nil, image: UIImage.init(named: "home"), tag: 0)
        homeIcon.imageInsets = iconInset
        homeController.tabBarItem = homeIcon
        
        let listController = ListViewController()
        let listIcon = UITabBarItem(title: nil, image: UIImage.init(named: "list"), tag: 0)
        listIcon.imageInsets = iconInset
        listController.tabBarItem = listIcon
        
        let settingsController = HomeViewController()
        let settingsIcon = UITabBarItem(title: nil, image: UIImage.init(named: "user"), tag: 0)
        settingsIcon.imageInsets = iconInset
        settingsController.tabBarItem = settingsIcon
        
        tabBarController.viewControllers = [homeController, listController, settingsController]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

