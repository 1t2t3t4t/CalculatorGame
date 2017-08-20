//
//  CalculatorGameViewController.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CalculatorGameViewController: UIViewController {
    
    @IBOutlet weak var timerLabel:UILabel!
    @IBOutlet weak var numberTextField:UITextField!
    @IBOutlet weak var choiceOne:UIButton!
    @IBOutlet weak var choiceTwo:UIButton!
    @IBOutlet weak var choiceThree:UIButton!
    @IBOutlet weak var choiceFour:UIButton!
    @IBOutlet weak var backButton:PressableButton!
    
    var viewModel:CalculatorGameViewModel = CalculatorGameViewModel()
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    var finishGame = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.numberTextField.layer.cornerRadius = 5.0
        self.numberTextField.layer.borderColor = UIColor(red: 56/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1).cgColor
        self.numberTextField.layer.borderWidth = 3.0
        
        backButton.colors = .init(button: UIColor(red: 70/255.0, green: 73/255.0, blue: 76/255.0, alpha: 1), shadow: UIColor(red: 25/255.0, green: 26/255.0, blue: 27/255.0, alpha: 1))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.checkPurchase(key: "purchase") == nil {
            startLoadingAd()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !finishGame {
            self.animateOpening {
                self.generateNewRound()
                self.startTimer()
            }
        }
    }
    
    
    @IBAction func buttonPressed(_ sender:UIButton) {
        guard let text = sender.titleLabel?.text else {
            return
        }
        guard let number = Int(text) else {
            return
        }
        self.viewModel.player.answer = number
        self.viewModel.checkAnswer()
        self.generateNewRound()
    }
    
    @IBAction func back(_ sender:UIButton) {
        print("backfromGame1")
       self.dismiss(animated: false, completion: nil)
        let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = vc

    }
    
    func animateOpening(withCompletion completion: @escaping completion) {
        let view = GetSetGoView.view as! GetSetGoView
        view.frame = self.view.frame
        self.view.addSubview(view)
        view.animateOpening(completion: completion)
    }
    
    func generateNewRound() {
        self.viewModel.problem = Problem()
        self.choiceOne.setTitle(self.viewModel.problem.choice[0], for: .normal)
        self.choiceTwo.setTitle(self.viewModel.problem.choice[1], for: .normal)
        self.choiceThree.setTitle(self.viewModel.problem.choice[2], for: .normal)
        self.choiceFour.setTitle(self.viewModel.problem.choice[3], for: .normal)
        self.numberTextField.text = self.viewModel.problem.text
    }
    
    func gameFinished() {
//        let message = "You've got \n \(self.viewModel.player.score) / 100 \nIn 100 seconds"
        let message = "\(self.viewModel.player.score)/60"
        self.viewModel.checkBestScore(score: self.viewModel.player.score)
        
        let resultView = ResultView.view as! ResultView
        resultView.frame = self.view.frame
        resultView.results = message
        resultView.gameObjectOnePlayer = self
        resultView.score = self.viewModel.player.score
        resultView.smallView.layer.cornerRadius = 10.0
        resultView.smallView.layer.masksToBounds = true
        self.view.addSubview(resultView)
        
        if UserDefaults.checkPurchase(key: "purchase") == nil {
            if interstitial.isReady  {
                interstitial.present(fromRootViewController: self)
            }
        }
        finishGame = true
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            let time = Int(self.timerLabel.text!)
            if time! <= 0 {
               self.gameFinished()
               Timer.invalidate()
            }else{
                self.timerLabel.text = "\(time!-10)"
            }
        }
    }
}

extension CalculatorGameViewController:GADBannerViewDelegate,GADInterstitialDelegate {
    
    func startLoadingAd() {
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.delegate = self
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1801504340872159/9929934680")
        interstitial.delegate = self
        
        bannerView.adUnitID = "ca-app-pub-1801504340872159/6996827191"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,"a8c6dfd7defadef3d2b95f64936479e5" ]
        bannerView.load(request)
        interstitial.load(request)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0.0
        bannerView.frame.origin.x = 0.0
        bannerView.frame.origin.y = self.view.frame.height - bannerView.frame.height
        self.view.addSubview(bannerView)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            bannerView.alpha = 1.0
            print("show banner now")
        }, completion: nil)
        
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
}

