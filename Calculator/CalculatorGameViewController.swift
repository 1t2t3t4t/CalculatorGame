//
//  CalculatorGameViewController.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit

class CalculatorGameViewController: UIViewController {
    
    @IBOutlet weak var timerLabel:UILabel!
    @IBOutlet weak var numberTextField:UITextField!
    @IBOutlet weak var choiceOne:UIButton!
    @IBOutlet weak var choiceTwo:UIButton!
    @IBOutlet weak var choiceThree:UIButton!
    @IBOutlet weak var choiceFour:UIButton!
    @IBOutlet weak var backButton:PressableButton!
    
    var viewModel:CalculatorGameViewModel = CalculatorGameViewModel()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.numberTextField.layer.cornerRadius = 5.0
        self.numberTextField.layer.borderColor = UIColor(red: 56/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1).cgColor
        self.numberTextField.layer.borderWidth = 3.0
        
        backButton.colors = .init(button: UIColor(red: 70/255.0, green: 73/255.0, blue: 76/255.0, alpha: 1), shadow: UIColor(red: 25/255.0, green: 26/255.0, blue: 27/255.0, alpha: 1))
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateOpening {
            self.generateNewRound()
            self.startTimer()
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
        let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        UIView.transition(with: window!, duration: 1.0, options: .curveEaseInOut, animations: {
            window?.rootViewController = vc
        }) { (finished) in
            //Finished animation
        }
    }
    
    func animateOpening(withCompletion completion: @escaping completion) {
        let view = GetSetGoView.view as! GetSetGoView
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
        let message = "You've got \n \(self.viewModel.player.score) / 100 \nIn 100 seconds" //\(self.viewModel.total)
        self.viewModel.checkBestScore(score: self.viewModel.player.score)
        let resultView = ResultView.view as! ResultView
        resultView.results = message
        resultView.smallView.layer.cornerRadius = 10.0
        resultView.smallView.layer.masksToBounds = true
        self.view.addSubview(resultView)
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
