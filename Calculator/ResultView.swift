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

protocol ResultViewDelegate:class {
    func didPressMainMenu() -> Void
    func restartGame() -> Void
    func shareApplication(activityController:UIActivityViewController) -> Void
}

class ResultView: UIView {
    
    @IBOutlet weak var smallView:UIView!
    @IBOutlet weak var resultField2: UITextField!
    @IBOutlet weak var viewForResult:UIView!
    @IBOutlet weak var resultField:UITextView!
    
    weak var delegate:ResultViewDelegate?
    weak var gameObjectOnePlayer:CalculatorGameViewController!
    weak var gameObjectTwoPlayer:TwoPlayersGameViewController!
    
    var twoPlayer = false
    var score = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        self.resultField.layer.cornerRadius = 5.0
        self.resultField2.isHidden = true
        self.resultField.layer.borderColor = UIColor(red: 56/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1).cgColor
        self.resultField.layer.borderWidth = 3.0
        self.resultField.layer.cornerRadius = 10.0
        self.resultField.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
    }
    
    var results:String! {
        didSet{
            resultField.text = results
        }
    }

    @IBAction func okClicked(_ sender:UIButton) {
        switch sender.tag {
        case 0:
            self.delegate?.restartGame()
            break
        case 1:
            shareApplication()
            break
        default:
            self.delegate?.didPressMainMenu()
        }
    }
    
    func shareApplication() {
       let firstActivityItem = "I've got \(score) out of 60 in 60 seconds. How much will you get? Let's find out!\nDownload 60:60 now."
        let secondActivityItem : NSURL = NSURL(string: "https://itunes.apple.com/us/app/60-60/id1273603001")!
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
        self.delegate?.shareApplication(activityController: activityViewController)
    }

}
