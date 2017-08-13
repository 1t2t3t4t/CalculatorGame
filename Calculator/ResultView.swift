//
//  ResultView.swift
//  Calculator
//
//  Created by Nathakorn on 8/1/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit

class ResultView: UIView {
    
    @IBOutlet weak var resulsLabel:UILabel!
    @IBOutlet weak var smallView:UIView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        resulsLabel.numberOfLines = 0
        resulsLabel.lineBreakMode = .byWordWrapping
    }
    
    var results:String! {
        didSet{
            self.resulsLabel.text = self.results
        }
    }

    @IBAction func okClicked(_ sender:UIButton) {
        switch sender.tag {
        case 0:
            let vc = CalculatorGameViewController.instantiateViewController() as! CalculatorGameViewController
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            UIView.transition(with: window!, duration: 0.5, options: .curveLinear, animations: {
                window?.rootViewController = vc
            }) { (finished) in
                //Finished animation
            }
        break
        case 1:
            break
        default:
            let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            UIView.transition(with: window!, duration: 1.0, options: .curveEaseInOut, animations: {
                window?.rootViewController = vc
            }) { (finished) in
                //Finished animation
            }
        
        }
    }
}
