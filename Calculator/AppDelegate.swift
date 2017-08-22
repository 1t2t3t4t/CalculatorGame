//
//  AppDelegate.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftyStoreKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         UIApplication.shared.isStatusBarHidden = false
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("purchased: \(purchase)")
                    UserDefaults.setPurchase(value: true, key: "purchase")
                
                }
            }
        }
        
        // Override point for customization after application launch.
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1801504340872159~6984207147")
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if shortcutItem.type == "com.stella.calculatorGame.onePlayer" {
            let vc = CalculatorGameViewController.instantiateViewController() as! CalculatorGameViewController
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            window?.rootViewController = vc
            completionHandler(true)
            
        }
        else if shortcutItem.type == "com.stella.calculatorGame.twoPlayer" {
            let vc = TwoPlayersGameViewController.instantiateViewController() as! TwoPlayersGameViewController
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            window?.rootViewController = vc
            completionHandler(true)
        }

        else {
            completionHandler(false)
        }
        
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

   
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

