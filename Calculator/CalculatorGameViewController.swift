//
//  CalculatorGameViewController.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation
class CalculatorGameViewController: UIViewController {
    
    @IBOutlet weak var timerLabel:UILabel!
    @IBOutlet weak var numberTextField:UITextField!
    @IBOutlet weak var choiceOne:UIButton!
    @IBOutlet weak var choiceTwo:UIButton!
    @IBOutlet weak var choiceThree:UIButton!
    @IBOutlet weak var choiceFour:UIButton!
    @IBOutlet weak var backButton:PressableButton!
    @IBOutlet weak var stackView:UIStackView!
    
    var viewModel:CalculatorGameViewModel = CalculatorGameViewModel()
    var bannerView:GADBannerView?
    var interstitial:GADInterstitial?
    var finishGame = false
    var timeObject:Timer!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.numberTextField.layer.cornerRadius = 5.0
        self.numberTextField.layer.borderColor = UIColor(red: 56/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1).cgColor
        self.numberTextField.layer.borderWidth = 3.0
        
        backButton.colors = .init(button: UIColor(red: 70/255.0, green: 73/255.0, blue: 76/255.0, alpha: 1), shadow: UIColor(red: 25/255.0, green: 26/255.0, blue: 27/255.0, alpha: 1))
       self.numberTextField.layer.sublayerTransform = CATransform3DMakeTranslation(-10,0,0)
        
        if UIDevice.isPadPro105 {
            stackView.spacing = 15
            choiceOne.titleLabel?.font = UIFont(name: "Digital-7", size: 32)
            choiceTwo.titleLabel?.font = UIFont(name: "Digital-7", size: 32)
            choiceThree.titleLabel?.font = UIFont(name: "Digital-7", size: 32)
            choiceFour.titleLabel?.font = UIFont(name: "Digital-7", size: 32)
        }

        
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
                        print("calculatorgame mute")
                        audioPlayer.volume = 0.0
                    }
                    audioPlayer.play()
                    
                }
                catch{
                    print(error)
                }
                
                self.generateNewRound()
                self.startTimer()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        audioPlayer.stop()
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
        self.viewModel.player.total+=1
        if self.viewModel.player.total >= 60 {
        
            self.gameFinished()
        }
        else {
             self.generateNewRound()
        }
    }
    
    @IBAction func back(_ sender:UIButton) {
       self.dismiss(animated: false, completion: nil)
        let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = vc
        self.clearAd()
    }
    
    func animateOpening(withCompletion completion: @escaping completion) {
        print("enteranimate")
        let view = GetSetGoView.view as! GetSetGoView
        view.playSound()
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
        timeObject.invalidate()
        let message = "\(self.viewModel.player.score)/60"
        GameCenterManager.sharedInstance.saveHighscore(number: self.viewModel.player.score)
        self.viewModel.checkBestScore(score: self.viewModel.player.score)
        let resultView = ResultView.view as! ResultView
        resultView.frame = self.view.frame
        resultView.delegate = self
        resultView.results = message
        resultView.gameObjectOnePlayer = self
        resultView.score = self.viewModel.player.score
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
    
    func clearAd() {
        self.bannerView?.removeFromSuperview()
        self.bannerView = nil
        self.interstitial = nil
    }
    
    func startTimer() {
        timeObject = Timer.scheduledTimer(timeInterval: 1, target: self,selector: (#selector(CalculatorGameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        let time = Int((self.timerLabel.text!))
        if time! <= 0 {
            self.gameFinished()
            timeObject?.invalidate()
        }else{
            self.timerLabel.text = "\(time!-1)"
        }
    }
}

extension CalculatorGameViewController: ResultViewDelegate {
    
    func restartGame() {
        self.dismiss(animated: false, completion:nil)
        let vc = CalculatorGameViewController.instantiateViewController() as! CalculatorGameViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = vc
        self.clearAd()
    }
    
    func didPressMainMenu() {
        self.dismiss(animated: false, completion:nil)
        let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = vc
        self.clearAd()
    }
    
    func shareApplication(activityController: UIActivityViewController) {
        self.present(activityController, animated: true, completion: nil)
    }
    
}

extension CalculatorGameViewController:GADBannerViewDelegate,GADInterstitialDelegate {
    
    func startLoadingAd() {
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView?.delegate = self
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1801504340872159/9929934680")
        interstitial?.delegate = self
        
        bannerView?.adUnitID = "ca-app-pub-1801504340872159/6996827191"
        bannerView?.rootViewController = self
        let request = GADRequest()
        // request.testDevices = [ kGADSimulatorID,"a8c6dfd7defadef3d2b95f64936479e5","86d4d9ee8f8969e52e74a106e72a5d54" ]
        bannerView?.load(request)
        interstitial?.load(request)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0.0
        bannerView.frame.origin.x = 0.0
        bannerView.frame.origin.y = self.view.frame.height - bannerView.frame.height
        bannerView.frame.size.width = self.view.frame.width
        self.view.addSubview(bannerView)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
           bannerView.alpha = 1.0
            print("show banner now")
        }, completion: nil)
    }
}

