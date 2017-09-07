//
//  ViewController.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import AVFoundation
import SpriteKit
import GameKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var numberTextField:UITextField!
    @IBOutlet weak var playGame:PressableButton!
    @IBOutlet weak var twoPlayer:PressableButton!
    @IBOutlet weak var more:PressableButton!
    @IBOutlet weak var leaderBoardButton:PressableButton!
    @IBOutlet dynamic weak var bestScore:UITextField!
    @IBOutlet weak var stackView:UIStackView!
    
    var bannerView: GADBannerView?
    
    var shouldRepeat = true
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UIDevice.isPadPro105 {
            stackView.spacing = 25
            numberTextField.font = UIFont(name: "Helvetica Neue", size: 44)
            bestScore.font = UIFont(name: "Helvetica Neue", size: 32)
        }
        else if UIDevice.deviceType == .iPhone5_5s {
            numberTextField.font = UIFont(name: "Helvetica Neue", size: 44)
        }
        
        leaderBoardButton.colors = .init(button: UIColor(red: 70/255.0, green: 73/255.0, blue: 76/255.0, alpha: 1), shadow: UIColor(red: 25/255.0, green: 26/255.0, blue: 27/255.0, alpha: 1))

        self.playGame.colors = .init(button: UIColor(red: 183/255.0, green: 60/255.0, blue: 54/255.0, alpha: 1), shadow: UIColor(red: 136/255.0, green: 45/255.0, blue: 41/255.0, alpha: 1))
        
        self.twoPlayer.colors = .init(button: UIColor(red: 221/255.0, green: 187/255.0, blue: 69/255.0, alpha: 1), shadow: UIColor(red: 162/255.0, green: 113/255.0, blue: 45/255.0, alpha: 1))
        
        self.more.colors = .init(button: UIColor(red: 78/255.0, green: 159/255.0, blue: 155/255.0, alpha: 1), shadow: UIColor(red: 56/255.0, green: 116/255.0, blue: 113/255.0, alpha: 1))
        
        self.numberTextField.layer.cornerRadius = 5.0
        self.numberTextField.layer.borderColor = UIColor(red: 56/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1).cgColor
        self.numberTextField.layer.borderWidth = 3.0
        //self.numberTextField.font = UIFont.font_autoAdjust(60)
        if UIDevice.deviceType == .iPhone4_4s {
            self.bestScore.font = UIFont.font_autoAdjust(17)
            self.numberTextField.font = UIFont.font_autoAdjust(58)
        }
        
        self.bestScore.adjustsFontSizeToFitWidth = true
        self.bestScore.minimumFontSize = 10
        
        GameCenterManager.authPlayer(withCompletion: {(view,error) in
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            }
        })
    
        if let bestScore = UserDefaults.loadScore(key: "bestScore") {
            self.bestScore.text = "BEST : \(bestScore)"
        }
        if shouldRepeat {
            do {
                print("test sound check \(UserDefaults.checkMute(key: "mute"))")
                audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:Bundle.main.path(forResource: "Winding_Down", ofType: "mp3")!))
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                if UserDefaults.checkMute(key: "mute"){
                    audioPlayer.volume = 0.0
                }
                audioPlayer.play()
            }
            catch{
                print(error)
            }
        }
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.checkPurchase(key: "purchase") == nil {
            startLoadingAd()
        }
    }
    
    deinit {
        self.bannerView?.removeFromSuperview()
        self.bannerView = nil
    }
    
    @IBAction func clickPlay(_ sender:Any?) {
       //self.performSegue(withIdentifier: Constant.SHOW_PROBLEM, sender: sender)
        let vc = CalculatorGameViewController.instantiateViewController() as! CalculatorGameViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = vc
    }
    
    @IBAction func twoPlayersClicked(_ sender:Any?) {
        let vc = TwoPlayersGameViewController.instantiateViewController() as! TwoPlayersGameViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = vc
        //self.performSegue(withIdentifier: Constant.SHOW_TWO_PLAYERS, sender: sender)
    }
    @IBAction func clickMore(_ sender:Any?) {
        let vc = MoreViewController.instantiateViewController() as! MoreViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = vc
       // self.performSegue(withIdentifier: Constant.SHOW_MORE, sender: sender)
    }
    
    @IBAction func clickLeaderBoard(_ sender:Any?){
        let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        
        gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
        
        
        gcViewController.leaderboardIdentifier = "com.stella.sixtysixty.highscore"
         self.present(gcViewController, animated: true, completion: nil)
    }

}

extension MainMenuViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

extension MainMenuViewController:GADBannerViewDelegate {
    
    func startLoadingAd() {
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView?.delegate = self
        
        bannerView?.adUnitID = "ca-app-pub-1801504340872159/5814595704"
        bannerView?.rootViewController = self
        let request = GADRequest()
        //request.testDevices = [ kGADSimulatorID,"a8c6dfd7defadef3d2b95f64936479e5","86d4d9ee8f8969e52e74a106e72a5d54" ]
        bannerView?.load(request)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0.0
        bannerView.frame.origin.x = 0.0
        bannerView.frame.origin.y = self.view.frame.height - bannerView.frame.height
        bannerView.frame.size.width = self.view.frame.width
        self.view.addSubview(bannerView)

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
          bannerView.alpha = 1.0
        }, completion: nil)
        
    }
    
}

