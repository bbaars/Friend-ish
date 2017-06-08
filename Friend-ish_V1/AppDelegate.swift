//
//  AppDelegate.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/8/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import Fabric
import TwitterKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /* Firebase Configure */
        FirebaseApp.configure()
        
        /* Facebook Authentication */
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Adding TwitterKit - Fabric
        Fabric.with([Twitter.self])
        
        /* API Key for Twitterkit - Fabric */
        GMSServices.provideAPIKey("AIzaSyAgvRmL0GrIUgHwllyT81ua8lhNHTVlg9M")
        
        /* load the data from firebase, this is an asyncronous process, should finish by the time the "viewDidLoad()" */
        //self.loadUserDataFromFirebase()
        
        /* Modify the UINavigationBar */
        let navigationAppearance = UINavigationBar.appearance()
        
        /* Changes the background to a blue/gray color */
        navigationAppearance.barTintColor = UIColor(red: 98/255, green: 114/255, blue: 123/255, alpha: 1.0)

        
        /* Changes the bar items to a white color */
        navigationAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir", size: 20.0)!]
        navigationAppearance.tintColor = UIColor.white
        
        
        /* Changes the status bar to a white theme, must have option in info.plist for this */
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        
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
    
    // handles the URLS on the app that allow the user to exit to login/accept Facebook and then returns
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}

