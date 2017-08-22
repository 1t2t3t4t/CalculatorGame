//
//  GetSetGoView.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit

typealias completion = () -> Void

class GetSetGoView: UIView {

    @IBOutlet weak var textLabel:UILabel!
        
    func animateOpening(_ string:String? = "READY??", completion: @escaping completion) {
        self.textLabel.text = string
        self.animateLabel { (done) in
            if string == "SET" {
                self.animateOpening("GO!!",completion: completion)
            }else if string == "READY??" {
                self.animateOpening("SET",completion: completion)
            }else {
                self.removeFromSuperview()
                completion()
            }
        }
    }
    
    func customAnimate(_ string:String, completion: completion? = nil) {
        self.textLabel.text = string
        self.animateLabel(1.2, withCompletion: {(done) in
                self.removeFromSuperview()
                if completion != nil { completion!() }
        })
    }
    
    private func animateLabel(_ duration:TimeInterval = 0.75, withCompletion completion: @escaping (Bool) -> Void) {
        self.textLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: duration, animations: {
            self.textLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: completion)
    }
}
