//
//  ResultView.swift
//  Calculator
//
//  Created by Nathakorn on 8/1/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit
import FacebookShare
import FBSDKShareKit

class ResultView: UIView {
    
    @IBOutlet weak var smallView:UIView!
    @IBOutlet weak var resultField: UITextField!
    @IBOutlet weak var viewForResult:UIView!
    
    var gameObject:CalculatorGameViewController!
    var twoPlayer = false
    var score = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.resultField.layer.cornerRadius = 5.0
        self.resultField.layer.borderColor = UIColor(red: 56/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1).cgColor
        self.resultField.layer.borderWidth = 3.0
        self.resultField.layer.cornerRadius = 10.0
    }
    
    var results:String! {
        didSet{
            resultField.text = results
        }
    }

    @IBAction func okClicked(_ sender:UIButton) {
        switch sender.tag {
        case 0:
            if twoPlayer {
                let vc = TwoPlayersGameViewController.instantiateViewController() as! TwoPlayersGameViewController
                let window = (UIApplication.shared.delegate as! AppDelegate).window
                UIView.transition(with: window!, duration: 0.5, options: .curveLinear, animations: {
                    window?.rootViewController = vc
                }) { (finished) in
                    //Finished animation
                }

            }
            else {
                let vc = CalculatorGameViewController.instantiateViewController() as! CalculatorGameViewController
                let window = (UIApplication.shared.delegate as! AppDelegate).window
                UIView.transition(with: window!, duration: 0.5, options: .curveLinear, animations: {
                    window?.rootViewController = vc
                }) { (finished) in
                    //Finished animation
                }

            }
            break
        case 1:
            shareApplication()
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
    
    func shareApplication() {
       let firstActivityItem = "I've got \(score) out of 60 in 60 seconds. How much will you get? Let's find out!\nDownload 60:60 now."
        let secondActivityItem : NSURL = NSURL(string: "https://www.google.com")!
        viewForResult.backgroundColor = UIColor(red: 227/255, green: 220/255, blue: 208/255, alpha: 1)
        let image : UIImage = viewForResult.asImage()
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem,image], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            UIActivityType.addToReadingList,
            UIActivityType.airDrop,
            UIActivityType.assignToContact,
            UIActivityType.openInIBooks,
            UIActivityType.saveToCameraRoll]
        gameObject.present(activityViewController, animated: true, completion: nil)
    }

}
