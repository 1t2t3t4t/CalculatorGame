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
        startLoadingAd()
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
        timeObject.invalidate()
        let view = PauseView.view as! PauseView
        view.twoPlayer = self
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
                self.timerLabelPlayerOne.text = "\(time!-10)"
                self.timerLabelPlayerTwo.text =  "\(time!-10)"
            }
        }
    }
    
    
    func gameFinished() {
        let playerOneScore = self.viewModel.playerOne.score
        let playerTwoScore = self.viewModel.playerTwo.score
        let message = "Player 1 Score is \(playerOneScore)\nPlayer 2 Score is \(playerTwoScore)"
        let resultView = ResultView.view as! ResultView
        resultView.results = message
        resultView.twoPlayer = true
        resultView.smallView.layer.cornerRadius = 10.0
        resultView.smallView.layer.masksToBounds = true
        self.view.addSubview(resultView)
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        finishGame = true
    }
    
    func animateOpening(withCompletion completion: @escaping completion) {
        let view = GetSetGoView.view as! GetSetGoView
        print(self.view)
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

