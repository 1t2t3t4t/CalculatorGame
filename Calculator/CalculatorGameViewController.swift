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
    
    var viewModel:CalculatorGameViewModel = CalculatorGameViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateOpening {
            //...
            self.generateNewRound()
            self.startTimer()
        }
    }
    
    @IBAction func buttonPressed(_ sender:UIButton) {
        guard let text = sender.titleLabel?.text else {
            return
        }
        guard let number = Int(text) else {
            if text.lowercased() == "enter" {
                self.viewModel.checkAnswer()
                self.generateNewRound()
            }else {
                self.viewModel.userAnswer.popLast()
            }
            numberTextField.text = self.viewModel.updateNumberField()
            return
        }
        self.viewModel.userAnswer += "\(number)"
        numberTextField.text = self.viewModel.updateNumberField()
    }
    
    func animateOpening(withCompletion completion: @escaping completion) {
        let view = GetSetGoView.view as! GetSetGoView
        self.view.addSubview(view)
        view.animateOpening(completion: completion)
    }
    
    func generateNewRound() {
        self.viewModel.generateProblem()
        self.numberTextField.text = self.viewModel.updateNumberField()
    }
    
    func gameFinished() {
        let message = "\(self.viewModel.correct)/\(self.viewModel.total)"
        let resultView = ResultView.view as! ResultView
        resultView.results = message
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
