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
    
    init() {
        
    }

}
