//
//  InAppManager.swift
//  Puzzle
//
//  Created by Nathakorn on 7/10/17.
//  Copyright © 2017 marky RE. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import UIKit
class InAppManager: NSObject {
    
    var moreObject:UIActivityIndicatorView!
    
    class func getProduct() {
        SwiftyStoreKit.retrieveProductsInfo(["com.stella.sixtysixty.unlockad"]) { result in
            print(result.retrievedProducts.count)
            
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if result.invalidProductIDs.first != nil {
                print("fuck up \(result.invalidProductIDs)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }
    
    func purchaseProduct() {
        SwiftyStoreKit.purchaseProduct("com.stella.sixtysixty.unlockad",atomically: true, applicationUsername:"puzzler",completion: { result in
            self.moreObject.removeFromSuperview()
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                UserDefaults.setPurchase(value: true, key: "purchase")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                }
            }
        })
    }
    
    func restorePurchase() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            self.moreObject.removeFromSuperview()
            if results.restoreFailedProducts.count > 0 {
                print("Restore Failed: \(results.restoreFailedProducts)")
            }
            else if results.restoredProducts.count > 0 {
                print("results ")
                 UserDefaults.setPurchase(value: true, key: "purchase")
                let alert = UIAlertController(title: "Success!", message: "Restore Purchase ฉomplete\nThank you!", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(confirm)
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
}
