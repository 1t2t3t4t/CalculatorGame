//
//  PauseView.swift
//  Calculator
//
//  Created by marky RE on 8/14/2560 BE.
//  Copyright © 2560 Nathakorn. All rights reserved.
//

import UIKit



class PauseView: UIView {

    @IBOutlet weak var continueButton:PressableButton!
    @IBOutlet weak var restartButton:PressableButton!
    @IBOutlet weak var mainMenuButton:PressableButton!
    
    var twoPlayer = TwoPlayersGameViewController()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    @IBAction func buttonClicked(_ sender:UIButton) {
        switch sender.tag {
        case 0:
            twoPlayer.startTimer()
            self.removeFromSuperview()
            
            break
        case 1:
               let vc = TwoPlayersGameViewController.instantiateViewController() as! TwoPlayersGameViewController
                let window = (UIApplication.shared.delegate as! AppDelegate).window
                UIView.transition(with: window!, duration: 0.5, options: .curveLinear, animations: {
                    window?.rootViewController = vc
                }) { (finished) in
                    //Finished animation
                }
                break
        default:
            let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            UIView.transition(with: window!, duration: 1.0, options: .curveEaseInOut, animations: {
                window?.rootViewController = vc
            }) { (finished) in
                //Finished animation
            }
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
