//
//  2PlayersGameViewController.swift
//  Calculator
//
//  Created by Nathakorn on 8/13/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TwoPlayersGameViewController: UIViewController {
    
    @IBOutlet var playerOneButtons:[UIButton]!
    @IBOutlet var playerTwoButtons:[UIButton]!
    
    @IBOutlet weak var playerOneTextField:UITextField!
    @IBOutlet weak var playerTwoTextField:UITextField!
    
    @IBOutlet weak var timerLabelPlayerOne:UILabel!
    @IBOutlet weak var timerLabelPlayerTwo:UILabel!
    
    @IBOutlet weak var pauseButton:PressableButton!
    
    var viewModel = TwoPlayersGameViewModel()
    var timeObject:Timer = Timer()
    var interstitial: GADInterstitial!
    var finishGame = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playerTwoTextField.transform =  CGAffineTransform(rotationAngle: CGFloat.pi)
        self.playerTwoTextField.layer.removeAllAnimations()
        self.timerLabelPlayerTwo.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.timerLabelPlayerTwo.layer.removeAllAnimations()
        
        for i in 0...3 {
           
            self.playerTwoButtons[i].transform = CGAffineTransform(rotationAngle: CGFloat.pi)
             self.playerTwoButtons[i].layer.removeAllAnimations()
        }
        
        pauseButton.tintColor = UIColor.white
        pauseButton.colors = .init(button: UIColor(red: 70/255.0, green: 73/255.0, blue: 76/255.0, alpha: 1), shadow: UIColor(red: 25/255.0, green: 26/255.0, blue: 27/255.0, alpha: 1))
        pauseButton.backgroundColor = UIColor.clear
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
            self.viewModel.addNewProblem()
            self.updatePlayerOneTextField()
            self.updatePlayerTwoTextField()
            self.startTimer()
        }
        }
    }
    
    @IBAction func playerOneDidAnswer(_ sender:UIButton) {
        guard let text = sender.titleLabel?.text else {
            return
        }
        guard let number = Int(text) else {
            return
        }
        self.viewModel.playerOne.answer = number
        self.viewModel.checkPlayerOneAnswer()
        self.updatePlayerOneTextField()
    }
    
    @IBAction func playerTwoDidAnswer(_ sender:UIButton) {
        guard let text = sender.titleLabel?.text else {
            return
        }
        guard let number = Int(text) else {
            return
        }
        self.viewModel.playerTwo.answer = number
        self.viewModel.checkPlayerTwoAnswer()
        self.updatePlayerTwoTextField()
    }
    
    @IBAction func clickPause(_ sender:Any?) {
        print("pause button")
        let view = PauseView.view as! PauseView
        view.frame = self.view.frame
        view.twoPlayer = self
        view.delegate = self
        timeObject.invalidate()
        self.view.addSubview(view)
       
    }
    
    func updatePlayerOneTextField() {
        let currentProblem = self.viewModel.playerOneCurrentProblem
        self.playerOneTextField.text = currentProblem.text
        for i in 0...3 {
            self.playerOneButtons[i].setTitle(currentProblem.choice[i], for: .normal)
        }
    }
    
    func updatePlayerTwoTextField() {
        let currentProblem = self.viewModel.playerTwoCurrentProblem
        self.playerTwoTextField.text = currentProblem.text
        for i in 0...3 {
            self.playerTwoButtons[i].setTitle(currentProblem.choice[i], for: .normal)
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.timeObject = Timer
            let time = Int(self.timerLabelPlayerOne.text!)
            if time! <= 0 {
                self.gameFinished()
                Timer.invalidate()
            }else{
                self.timerLabelPlayerOne.text = "\(time!-100)"
                self.timerLabelPlayerTwo.text =  "\(time!-100)"
            }
        }
    }
    
    
    func gameFinished() {
        let playerOneScore = self.viewModel.playerOne.score
        let playerTwoScore = self.viewModel.playerTwo.score
        let message = "\nPlayer 1 Score\n\(playerOneScore)/60\n\nPlayer 2 Score\n\(playerTwoScore)/60"
        let resultView = ResultView.view as! ResultView
        resultView.resultField.font = UIFont(name: "Digital-7MonoItalic", size: 25.0)
        resultView.results = message
        resultView.frame = self.view.frame
        resultView.gameObjectTwoPlayer = self
        resultView.twoPlayer = true
        print("hello my nig")
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
    
    func animateOpening(withCompletion completion: @escaping completion) {
        let view = GetSetGoView.view as! GetSetGoView
        view.frame = self.view.frame
        self.view.addSubview(view)
        view.animateOpening(completion: completion)
    }
    
    
}

extension TwoPlayersGameViewController:GADInterstitialDelegate {
    
    func startLoadingAd() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1801504340872159/9048275468")
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,"a8c6dfd7defadef3d2b95f64936479e5" ]
        interstitial.load(request)
    }
    
    /// Tells the delegate an ad request failed.
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

extension TwoPlayersGameViewController: PauseViewDelegate {
    
    func restartGame() {
        self.dismiss(animated: false) {
            let vc = TwoPlayersGameViewController.instantiateViewController() as! TwoPlayersGameViewController
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            UIView.transition(with: appdelegate.window!, duration: 0.5, options: .curveLinear, animations: {
                appdelegate.window?.rootViewController = vc
            }) { (finished) in
                //Finished animation
            }
        }
    }
    
    func didPressedMainMenu() {
        self.dismiss(animated: false, completion: {
            let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            window?.rootViewController = vc
        })
    }
    func resumeGame() {
        self.startTimer()
    }
}

