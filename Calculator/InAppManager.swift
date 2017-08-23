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

typealias restoreCompletion = (Bool) -> Void

class InAppManager: NSObject {
    
    var moreObject:UIActivityIndicatorView!
    
    class func getProduct() {
        SwiftyStoreKit.retrieveProductsInfo(["com.stella.sixtysixty.unlockad"]) { result in
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
    
    func purchaseProduct(withCompletion completion: @escaping restoreCompletion) {
        SwiftyStoreKit.purchaseProduct("com.stella.sixtysixty.unlockad",atomically: true, applicationUsername:"puzzler",completion: { result in
            self.moreObject.removeFromSuperview()
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                UserDefaults.setPurchase(value: true, key: "purchase")
                completion(true)
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
                completion(false)
            }
        })
    }
    
    func restorePurchase(withCompletion completion: @escaping restoreCompletion) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            self.moreObject.removeFromSuperview()
            if results.restoreFailedProducts.count > 0 {
                let alert = UIAlertController(title: "Unsuccessful", message: "Cannot Restore Purchase\nPlease try again", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(confirm)
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                print("Restore Failed: \(results.restoreFailedProducts)")
                completion(false)
            }
            else if results.restoredProducts.count > 0 {
                print("results ")
                 UserDefaults.setPurchase(value: true, key: "purchase")
                let alert = UIAlertController(title: "Success!", message: "Restore Purchase complete\nThank you!", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(confirm)
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                completion(true)
            }
            else {
                print("Nothing to Restore")
                let alert = UIAlertController(title: "Unsuccessful", message: "Nothing to restore", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(confirm)
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                completion(false)
            }
        }
    }
}
