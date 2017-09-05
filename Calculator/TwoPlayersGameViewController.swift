//
//  2PlayersGameViewController.swift
//  Calculator
//
//  Created by Nathakorn on 8/13/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation

class TwoPlayersGameViewController: UIViewController {
    
    @IBOutlet var playerOneButtons:[UIButton]!
    @IBOutlet var playerTwoButtons:[UIButton]!
    
    @IBOutlet weak var playerOneTextField:UITextField!
    @IBOutlet weak var playerTwoTextField:UITextField!
    
    @IBOutlet weak var timerLabelPlayerOne:UILabel!
    @IBOutlet weak var timerLabelPlayerTwo:UILabel!
    
    @IBOutlet weak var playerOneView: UIView!
    @IBOutlet weak var playerTwoView: UIView!
    
    @IBOutlet weak var pauseButton:PressableButton!
    
    var viewModel = TwoPlayersGameViewModel()
    var timeObject:Timer!
    var interstitial: GADInterstitial?
    var finishGame = false
    var exceed = false
    var doneView:GetSetGoView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playerOneTextField.layer.sublayerTransform = CATransform3DMakeTranslation(-10,3,0)
        
        self.playerTwoTextField.transform =  CGAffineTransform(rotationAngle: CGFloat.pi)
        self.playerTwoTextField.layer.sublayerTransform = CATransform3DMakeTranslation(-10,3, 0)
        self.playerTwoTextField.layer.removeAllAnimations()
        
        self.timerLabelPlayerTwo.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.timerLabelPlayerTwo.layer.removeAllAnimations()
        
        for i in 0...3 {
            self.playerOneButtons[i].titleLabel?.font = UIFont.font_autoAdjust(44.fontSize)
            self.playerOneButtons[i].contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
            
            self.playerTwoButtons[i].transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.playerTwoButtons[i].titleLabel?.font = UIFont.font_autoAdjust(44.fontSize)
            if i == 3 {
                self.playerTwoButtons[i].contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            }
            else {
                self.playerTwoButtons[i].contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            }
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
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:Bundle.main.path(forResource: "Hypnotic-Puzzle4", ofType: "mp3")!))
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                    try AVAudioSession.sharedInstance().setActive(true)
                    audioPlayer.numberOfLoops = -1
                    audioPlayer.prepareToPlay()
                    if UserDefaults.checkMute(key: "mute") {
                        print("mute twoplayer")
                        audioPlayer.volume = 0.0
                    }
                    audioPlayer.play()
                }
                catch{
                    print(error)
                }

                self.viewModel.addNewProblem()
                self.updatePlayerOneTextField()
                self.updatePlayerTwoTextField()
                self.startTimer()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        audioPlayer.stop()
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
        print(self.viewModel.playerOne.total)
        if self.viewModel.playerOne.total >= 60 {
             playerExceedLimit(player:playerOneView)
        }
        else {
        self.updatePlayerOneTextField()
        }
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
        if self.viewModel.playerTwo.total >= 60 {
            playerExceedLimit(player:playerTwoView)
        }
        else {
            self.updatePlayerTwoTextField()
        }
    }
    
    @IBAction func clickPause(_ sender:Any?) {
        print("clickpause")
        let view = PauseView.view as! PauseView
        view.frame = self.view.frame
        view.twoPlayer = self
        view.delegate = self
        print("timeobject \(timeObject)")
        timeObject?.invalidate()
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
    
    func playerExceedLimit(player:UIView) {
        if exceed {
            doneView?.removeFromSuperview()
            timeObject?.invalidate()
            self.animateResult()
        }
        else {
            exceed = true
            self.doneView = (GetSetGoView.view as! GetSetGoView)
            doneView.textLabel.text = "Done"
            audioPlayer.play()
            doneView.frame = self.playerOneView.bounds
            if player == self.playerTwoView {
                doneView.transform = CGAffineTransform(rotationAngle: .pi)
            }
            player.addSubview(doneView!)
        }

    }
    
    func startTimer() {
         timeObject = Timer.scheduledTimer(timeInterval: 1, target: self,selector: (#selector(TwoPlayersGameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        let time = Int((self.timerLabelPlayerOne.text!))
        if time! <= 0 {
            doneView?.removeFromSuperview()
            self.animateResult()
            timeObject?.invalidate()
        }else{
            self.timerLabelPlayerOne.text = "\(time!-1)"
            self.timerLabelPlayerTwo.text =  "\(time!-1)"
        }
    }
    
    func animateResult() {
        let one = GetSetGoView.view as! GetSetGoView
        let two = GetSetGoView.view as! GetSetGoView
        two.transform = CGAffineTransform(rotationAngle: .pi)
        one.frame = self.playerOneView.bounds
        two.frame = self.playerTwoView.bounds
        self.playerOneView.addSubview(one)
        self.playerTwoView.addSubview(two)
        one.customAnimate(self.viewModel.isPlayerOneWin().toString)
        two.customAnimate(self.viewModel.isPlayerTwoWin().toString) { 
            self.gameFinished()
        }
    }
    
    func gameFinished() {
        let resultView = ResultView.view as! ResultView
        resultView.delegate = self
        resultView.resultField.font = UIFont(name: "Digital-7MonoItalic", size: 28.0)
        
        resultView.results = self.viewModel.resultMessage
        resultView.frame = self.view.frame
        resultView.gameObjectTwoPlayer = self
        resultView.twoPlayer = true
        resultView.smallView.layer.cornerRadius = 10.0
        resultView.smallView.layer.masksToBounds = true
        self.view.addSubview(resultView)
        if UserDefaults.checkPurchase(key: "purchase") == nil && interstitial != nil {
            if (interstitial?.isReady)!  {
                interstitial?.present(fromRootViewController: self)
            }
        }
        finishGame = true
    }
    
    func animateOpening(withCompletion completion: @escaping completion) {
        let view = GetSetGoView.view as! GetSetGoView
        view.playSound()
        view.frame = self.view.frame
        self.view.addSubview(view)
        view.animateOpening(completion: completion)
    }
}

extension TwoPlayersGameViewController:GADInterstitialDelegate {
    
    func startLoadingAd() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1801504340872159/9048275468")
        interstitial?.delegate = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,"a8c6dfd7defadef3d2b95f64936479e5","86d4d9ee8f8969e52e74a106e72a5d54" ]
        interstitial?.load(request)
    }
    
}

extension TwoPlayersGameViewController: PauseViewDelegate,ResultViewDelegate {
    
    func restartGame() {
        self.dismiss(animated: false,completion: nil)
        let vc = TwoPlayersGameViewController.instantiateViewController() as! TwoPlayersGameViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window?.rootViewController = vc
        self.interstitial = nil
    }
    
    func didPressMainMenu() {
        self.dismiss(animated: false, completion:nil)
        let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = vc
        self.interstitial = nil
    }
    
    func shareApplication(activityController: UIActivityViewController) {
        self.present(activityController, animated: true, completion: nil)
    }
    
    func resumeGame() {
        self.startTimer()
    }
}
