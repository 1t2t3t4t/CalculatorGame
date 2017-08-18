//
//  Problem.swift
//  Calculator
//
//  Created by Nathakorn on 8/12/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation

struct Problem {
    
    var choice:[String] = []
    var text = ""
    var answer:Int! = 0
    var selectedChoice = 0
    
    init() {
        self.text = "\(randomInt(num: 9))+\(randomInt(num: 9))+\(randomInt(num: 9))+\(randomInt(num: 9))"
        self.answer = NSExpression(format: self.text).expressionValue(with: nil, context: nil) as! Int
        choice = ["\(self.answer-1)","\(self.answer-2)","\(self.answer+1)","\(self.answer+2)"]
        choice[randomInt(num: 4)-1] = "\(self.answer!)"
        self.shuffleChoices()
    }
    
    mutating func shuffleChoices() {
        for i in 0...3 {
            let index = randomInt(num: 4)-1
            let temp = self.choice[i]
            self.choice[i] = self.choice[index]
            self.choice[index] = temp
        }
    }
}
