//
//  CalculatorGameViewModel.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation


class CalculatorGameViewModel {
    
    var answer:Int! = 0
    var userAnswer = 0
    var problem = ""
    var total:Int = 100
    var correct:Int = 0
    var choice:[String] = []
    var selectedChoice = 0
    var count = 0
    
    func generateProblem() {
        
        count = 0
        selectedChoice = 0
        
        self.problem = "\(randomInt(num: 9))\(self.getRandomOperation())\(randomInt(num: 9))" + "\(self.getRandomOperation())\(randomInt(num: 9))" + "\(self.getRandomOperation())\(randomInt(num: 9))"
        
        self.answer = NSExpression(format: self.problem).expressionValue(with: nil, context: nil) as! Int
        
        choice = ["\(self.answer-1)","\(self.answer-2)","\(self.answer+1)","\(self.answer+2)"]
        print("after choice \(self.answer)")
        
        selectedChoice = Int(arc4random_uniform(UInt32(choice.count)))
    }
    
    func generateChoice() -> String{
        if count == selectedChoice {
            count+=1
            return "\(self.answer!)"
        }
        else {
            count+=1
            let num = Int(arc4random_uniform(UInt32(choice.count)))
            let temp = choice[num]
            choice.remove(at: num)
            return temp
        }
        
    }
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
        if self.userAnswer == self.answer {
            self.correct += 1
        }
    }
    
    func getRandomOperation() -> String {
        return "+"
        //return randomInt(num: 2) == 1 ? "+" : "-"
    }
    
    func updateNumberField() -> String {
        return self.problem
    }

}
