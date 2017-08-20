//
//  PauseView.swift
//  Calculator
//
//  Created by marky RE on 8/14/2560 BE.
//  Copyright © 2560 Nathakorn. All rights reserved.
//

import UIKit

protocol PauseViewDelegate:class {
    func didPressedMainMenu() -> Void
    func restartGame() -> Void
    func resumeGame() -> Void
}


class PauseView: UIView {

    @IBOutlet weak var continueButton:PressableButton!
    @IBOutlet weak var restartButton:PressableButton!
    @IBOutlet weak var mainMenuButton:PressableButton!
    
    weak var delegate:PauseViewDelegate?
    var twoPlayer = TwoPlayersGameViewController()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    @IBAction func buttonClicked(_ sender:UIButton) {
        switch sender.tag {
        case 0:
            self.delegate?.resumeGame()
            break
        case 1:
           self.delegate?.restartGame()
                break
        default:
            self.delegate?.didPressedMainMenu()
            break
            
        }
       
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
