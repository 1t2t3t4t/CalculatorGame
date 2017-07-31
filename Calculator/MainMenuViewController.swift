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

    @IBAction func clickPlay(_ sender:Any?) {
        print(String(describing: self))
        self.performSegue(withIdentifier: Constant.DIFFICULTY_SELECTION, sender: sender)
    }
    
}

