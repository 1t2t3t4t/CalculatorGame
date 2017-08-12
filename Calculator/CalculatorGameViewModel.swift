//
//  CalculatorGameViewModel.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation


class CalculatorGameViewModel {
    
    var userAnswer = 0
    var total:Int = 100
    var correct:Int = 0
    var count = 0
    
    var problem = Problem()
    
    func checkBestScore(score:Int) {
        if let best = UserDefaults.loadScore(key: "bestScore") {
            if best < score {
                UserDefaults.saveScore(value: score, key: "bestScore")
            }
        }
        else {
            UserDefaults.saveScore(value: score, key: "bestScore")
        }
    }
    
    func checkAnswer() {
        if self.userAnswer == self.problem.answer {
            self.correct += 1
        }
    }
    
}
