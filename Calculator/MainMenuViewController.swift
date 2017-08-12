//
//  ViewController.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {
    @IBOutlet weak var numberTextField:UITextField!
    @IBOutlet weak var playGame:PressableButton!
    @IBOutlet weak var twoPlayer:PressableButton!
    @IBOutlet weak var aboutUs:PressableButton!
    @IBOutlet weak var bestScore:UITextField!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.playGame.colors = .init(button: UIColor(red: 183/255.0, green: 60/255.0, blue: 54/255.0, alpha: 1), shadow: UIColor(red: 136/255.0, green: 45/255.0, blue: 41/255.0, alpha: 1))
        
        self.twoPlayer.colors = .init(button: UIColor(red: 221/255.0, green: 187/255.0, blue: 69/255.0, alpha: 1), shadow: UIColor(red: 162/255.0, green: 113/255.0, blue: 45/255.0, alpha: 1))
        
        self.aboutUs.colors = .init(button: UIColor(red: 78/255.0, green: 159/255.0, blue: 155/255.0, alpha: 1), shadow: UIColor(red: 56/255.0, green: 116/255.0, blue: 113/255.0, alpha: 1))
        
        self.numberTextField.layer.cornerRadius = 5.0
        self.numberTextField.layer.borderColor = UIColor(red: 56/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1).cgColor
        self.numberTextField.layer.borderWidth = 3.0
        
        self.bestScore.text = "BEST : \(UserDefaults.loadScore(key: "bestScore")!)"
    }
    @IBAction func clickPlay(_ sender:Any?) {
        print(String(describing: self))
        self.performSegue(withIdentifier: Constant.SHOW_PROBLEM, sender: sender)
    }
    
}

