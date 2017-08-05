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
    
    var results:String! {
        didSet{
            self.resulsLabel.text = self.results
        }
    }

    @IBAction func okClicked(_ sender:UIButton) {
        let vc = MainMenuViewController.instantiateViewController() as! MainMenuViewController
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        UIView.transition(with: window!, duration: 0.5, options: .transitionCurlDown, animations: {
            window?.rootViewController = vc
        }) { (finished) in
            //Finished animation
        }
    }
}
