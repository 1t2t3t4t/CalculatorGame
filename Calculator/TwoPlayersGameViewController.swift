//
//  2PlayersGameViewController.swift
//  Calculator
//
//  Created by Nathakorn on 8/13/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit

class TwoPlayersGameViewController: UIViewController {
    
    @IBOutlet weak var PlayerTwoView: UIView!
    @IBOutlet weak var PlayerOneView: UIView!
    
    @IBOutlet var playerOneButtons:[UIButton]!
    @IBOutlet var playerTwoButtons:[UIButton]!
    
    @IBOutlet weak var playerOneTextField:UITextField!
    @IBOutlet weak var playerTwoTextField:UITextField!
    
    @IBOutlet weak var playerOneTimerLabel:UILabel!
    @IBOutlet weak var playerTwoTimerLabel:UILabel!

    var viewModel = TwoPlayersGameViewModel()
    var timerObj:Timer!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playerTwoTextField.transform =  CGAffineTransform(rotationAngle: CGFloat.pi)
        self.playerTwoTextField.layer.removeAllAnimations()
        self.playerTwoTimerLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.playerTwoTimerLabel.layer.removeAllAnimations()
        for i in 0...3 {
            self.playerTwoButtons[i].transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.playerTwoButtons[i].layer.removeAllAnimations()
        }
        self.playerOneTextField.layer.cornerRadius = 5.0
        self.playerOneTextField.layer.borderColor = UIColor(red: 56/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1).cgColor
        self.playerOneTextField.layer.borderWidth = 3.0
        
        self.playerTwoTextField.layer.cornerRadius = 5.0
        self.playerTwoTextField.layer.borderColor = UIColor(red: 56/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1).cgColor
        self.playerTwoTextField.layer.borderWidth = 3.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateOpening {
            self.viewModel.addNewProblem()
            self.updatePlayerOneTextField()
            self.updatePlayerTwoTextField()
            self.startTimer()
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
    
    @IBAction func pause(_ sender:UIButton) {
        let pauseView = PauseView.view as! PauseView
        pauseView.frame = self.view.bounds
        pauseView.delegate = self
        pauseView.twoPlayer = self
        timerObj.invalidate()
        self.view.addSubview(pauseView)
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
            let time = Int(self.playerOneTimerLabel.text!)
            self.timerObj = Timer
            if time! <= 0 {
                self.gameFinished()
                Timer.invalidate()
            }else{
                self.playerOneTimerLabel.text = "\(time!-10)"
                self.playerTwoTimerLabel.text = "\(time!-10)"
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
        resultView.frame = self.view.bounds
        resultView.smallView.layer.cornerRadius = 10.0
        resultView.smallView.layer.masksToBounds = true
        self.view.addSubview(resultView)
    }
    
    func animateOpening(withCompletion completion: @escaping completion) {
        let playerOneView = GetSetGoView.view as! GetSetGoView
        let playerTwoView = GetSetGoView.view as! GetSetGoView
        let bound = self.PlayerOneView.bounds
        playerOneView.frame = bound
        playerTwoView.frame = bound
        playerTwoView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.PlayerOneView.addSubview(playerOneView)
        self.PlayerTwoView.addSubview(playerTwoView)
        playerOneView.animateOpening("PLAYER ONE", completion: nil)
        playerTwoView.animateOpening("PLAYER TWO", completion: completion)
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

    func didPressedMainMenu(pauseView: PauseView) {
        self.dismiss(animated: false, completion: {
            let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            window?.rootViewController = vc
        })
    }
}
