//
//  MoreViewController.swift
//  Calculator
//
//  Created by marky RE on 8/13/2560 BE.
//  Copyright © 2560 Nathakorn. All rights reserved.
//

import UIKit
import Social
import MessageUI
import FacebookShare
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMobileAds
import SwiftyStoreKit

class MoreViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var shareApp:PressableButton!
    @IBOutlet weak var rateUs:PressableButton!
    @IBOutlet weak var contactUs:PressableButton!
    @IBOutlet weak var removeAd:PressableButton!
    @IBOutlet weak var restorePurchase:PressableButton!
    @IBOutlet weak var backButton:PressableButton!
    
    var bannerView: GADBannerView!
    var indicator = UIActivityIndicatorView()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.colors = .init(button: UIColor(red: 70/255.0, green: 73/255.0, blue: 76/255.0, alpha: 1), shadow: UIColor(red: 25/255.0, green: 26/255.0, blue: 27/255.0, alpha: 1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.midX-40, y: self.view.frame.midY-40, width: 80, height: 80))
        indicator.layer.cornerRadius = 10.0
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.backgroundColor = UIColor.darkGray
        if UserDefaults.checkPurchase(key: "purchase") == nil {
            startLoadingAd()
        }
        InAppManager.getProduct()
        
    }
    
    @IBAction func back(_ sender:Any?) {
        self.dismiss(animated: false, completion: nil)
        let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = vc
    }
    
    @IBAction func buttonAction(_ sender:PressableButton) {
        let inApp = InAppManager()

        self.view.addSubview(indicator)
        switch sender.tag {
        case 0:
            shareApplication()
            break
        case 1:
            rateApp()
            break
        case 2:
            sendEmail()
            break
        case 3:
            inApp.moreObject = indicator
            indicator.startAnimating()
            inApp.purchaseProduct()
            break
        default:
            inApp.moreObject = indicator
            indicator.startAnimating()
            inApp.restorePurchase()
            break
        }
    }
    
    func shareApplication() {
        let firstActivityItem = "How fast can you do this math quiz in 60 seconds?\nLet's find out!\n"
        let secondActivityItem : NSURL = NSURL(string: "https://www.google.com")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            UIActivityType.addToReadingList,
            UIActivityType.airDrop,
            UIActivityType.assignToContact,
            UIActivityType.openInIBooks,
            UIActivityType.saveToCameraRoll
        ]
        self.indicator.removeFromSuperview()
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func rateApp() {
        RateMyApp.sharedInstance.okButtonPressed()
    }
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["stellateamdev@gmail.com"])
        // Present the view controller modally.
        self.indicator.removeFromSuperview()
        self.present(composeVC, animated: true, completion: {})
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        self.indicator.removeFromSuperview()
        controller.dismiss(animated: true, completion:{})
    }
}

extension MoreViewController:GADBannerViewDelegate {
    
    func startLoadingAd() {
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-1801504340872159/2434588045"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,"a8c6dfd7defadef3d2b95f64936479e5" ]
        bannerView.load(request)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0.0
        bannerView.frame.origin.x = 0.0
        bannerView.frame.origin.y = self.view.frame.height - bannerView.frame.height
        self.view.addSubview(bannerView)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            bannerView.alpha = 1.0
        }, completion: nil)
        
    }
    
}


