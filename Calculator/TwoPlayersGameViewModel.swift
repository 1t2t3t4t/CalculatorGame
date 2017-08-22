//
//  TwoPlayersGameViewModel.swift
//  Calculator
//
//  Created by Nathakorn on 8/13/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation

class TwoPlayersGameViewModel {
    
    var problems:[Problem] = []
    
    var playerOne = Player()
    var playerTwo = Player()
    
    var resultMessage: String {
        return "\nPlayer 1 Score\n\(self.playerOne.score)/60\n\nPlayer 2 Score\n\(self.playerTwo.score)/60"
    }
    
    var playerOneCurrentProblem:Problem {
        return self.problems[self.playerOne.total]
    }
    
    var playerTwoCurrentProblem:Problem {
        return self.problems[self.playerTwo.total]
    }
    
    func addNewProblem() {
        problems.append(Problem())
    }
    
    func checkPlayerOneAnswer() {
        if self.playerOne.answer == self.playerOneCurrentProblem.answer {
            self.playerOne.score += 1
        }
        self.playerOne.total += 1
        self.addNewProblem()
    }
    
    func checkPlayerTwoAnswer() {
        if self.playerTwo.answer == self.playerTwoCurrentProblem.answer {
            self.playerTwo.score += 1
        }
        self.playerTwo.total += 1
        self.addNewProblem()
    }
    
}
