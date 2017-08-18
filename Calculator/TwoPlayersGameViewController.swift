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
    
    @IBOutlet weak var timerLabel:UILabel!
    
    var viewModel = TwoPlayersGameViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playerTwoTextField.transform =  CGAffineTransform(rotationAngle: CGFloat.pi)
        self.playerTwoTextField.layer.removeAllAnimations()
        for i in 0...3 {
            self.playerTwoButtons[i].transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.playerTwoButtons[i].layer.removeAllAnimations()
        }
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
            let time = Int(self.timerLabel.text!)
            if time! <= 0 {
                self.gameFinished()
                Timer.invalidate()
            }else{
                self.timerLabel.text = "\(time!-10)"
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
        playerOneView.animateOpening("PLAYER ONE") { 
            
        }
        playerTwoView.animateOpening("PLAYER TWO", completion: completion)
    }
}
