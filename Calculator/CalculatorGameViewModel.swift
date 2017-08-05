//
//  CalculatorGameViewModel.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation

enum Difficulty {
    case easy
    case normal
    case hard
    case difficulty(withString:String)
}

extension Difficulty {
    func stringToDifficulty() -> Difficulty {
        switch self {
        case .difficulty(withString: let string):
            if string == "easy" { return .easy }
            else if string == "normal" { return .normal }
            else { return .hard }
        default:
            return self
        }
    }
}

class CalculatorGameViewModel {
    
    var difficulty:Difficulty!
    var answer:Int! = 0
    var userAnswer = ""
    var problem = ""
    var total:Int = 100
    var correct:Int = 0
    
    func generateProblem() {
        self.userAnswer = ""
        var first = randomInt(fromOneUpTo: 99)
        var second = randomInt(fromOneUpTo: 99)
        let operation = self.getRandomOperation()
        if first < second && operation == "-" {
            let temp = first
            first = second
            second = temp
        }
        self.problem = "\(first)\(operation)\(second)"
        self.answer = NSExpression(format: self.problem).expressionValue(with: nil, context: nil) as! Int
    }
    
    func checkAnswer() {
        guard let userAns = Int(self.userAnswer) else {
            return
        }
        if userAns == self.answer {
            self.correct += 1
        }
    }
    
    func getRandomOperation() -> String {
        return randomInt(fromOneUpTo: 2) == 1 ? "+" : "-"
    }
    
    func updateNumberField() -> String {
        return problem+" = "+userAnswer
    }

}
