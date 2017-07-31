//
//  CalculatorGameViewController.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit

class CalculatorGameViewController: UIViewController {
    
    @IBOutlet weak var timerLabel:UILabel!
    @IBOutlet weak var numberTextField:UITextField!
    
    var viewModel:CalculatorGameViewModel = CalculatorGameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateOpening {
            //...
        }
    }
    
    @IBAction func buttonPressed(_ sender:UIButton) {
        guard let number = Int(sender.titleLabel!.text!) else {
            if sender.titleLabel!.text!.lowercased() == "enter" {
            }else {
                numberTextField.text!--
            }
            return
        }
        numberTextField.text +=  "\(number)"
    }
    
    func animateOpening(withCompletion completion: @escaping completion) {
        let view = GetSetGoView.view as! GetSetGoView
        self.view.addSubview(view)
        view.animateOpening(completion: completion)
    }
}
