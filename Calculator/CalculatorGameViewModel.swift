//
//  CalculatorGameViewModel.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation


class CalculatorGameViewModel {
    
    var player = Player()
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
        if self.player.answer == self.problem.answer {
            self.player.score += 1
        }
    }
}
