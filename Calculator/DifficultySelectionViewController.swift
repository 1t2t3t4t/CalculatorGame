//
//  DifficultySelectionViewController.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit



class DifficultySelectionViewController: UIViewController {

    @IBAction func selectedDifficulty(_ sender:UIButton) {
        let vc = CalculatorGameViewController.instantiateViewController() as! CalculatorGameViewController
        vc.viewModel.difficulty = Difficulty.difficulty(withString: sender.titleLabel!.text!.lowercased())
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        UIView.transition(with: window!, duration: 0.5, options: .transitionCurlUp, animations: {
            window?.rootViewController = vc
        }) { (finished) in
            //Finished animation
        }
    }

}
