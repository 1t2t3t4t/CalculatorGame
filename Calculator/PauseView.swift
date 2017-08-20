//
//  PauseView.swift
//  Calculator
//
//  Created by Nathakorn on 8/19/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit

protocol PauseViewDelegate:class {
    func didPressedMainMenu(pauseView:PauseView) -> Void
    func restartGame() -> Void
}

class PauseView: UIView {
    
    weak var delegate:PauseViewDelegate?
    var twoPlayer:TwoPlayersGameViewController?
    @IBAction func resume(_ sender:UIButton?) {
        self.removeFromSuperview()
        twoPlayer?.startTimer()
    }
    
    @IBAction func restart(_ sender:UIButton?) {
        let vc = TwoPlayersGameViewController.instantiateViewController() as! TwoPlayersGameViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        UIView.transition(with: appdelegate.window!, duration: 0.5, options: .curveLinear, animations: {
            appdelegate.window?.rootViewController = vc
        }) { (finished) in
            //Finished animation
        }
        self.removeFromSuperview()
    }
    
    @IBAction func mainMenu(_ sender:UIButton?) {
        self.delegate?.didPressedMainMenu(pauseView: self)
    }
}
