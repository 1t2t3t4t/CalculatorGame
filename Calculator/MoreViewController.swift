//
//  MoreViewController.swift
//  Calculator
//
//  Created by marky RE on 8/13/2560 BE.
//  Copyright © 2560 Nathakorn. All rights reserved.
//

import UIKit
import Social
class MoreViewController: UIViewController {
    @IBOutlet weak var shareApp:PressableButton!
    @IBOutlet weak var rateUs:PressableButton!
    @IBOutlet weak var contactUs:PressableButton!
    @IBOutlet weak var removeAd:PressableButton!
    @IBOutlet weak var restorePurchase:PressableButton!
    @IBOutlet weak var backButton:PressableButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.colors = .init(button: UIColor(red: 70/255.0, green: 73/255.0, blue: 76/255.0, alpha: 1), shadow: UIColor(red: 25/255.0, green: 26/255.0, blue: 27/255.0, alpha: 1))
    }

    @IBAction func back(_ sender:Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonAction(_ sender:PressableButton) {
        switch sender.tag {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
    }
}
