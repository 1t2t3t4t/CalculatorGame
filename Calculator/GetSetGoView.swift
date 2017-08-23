//
//  GetSetGoView.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import UIKit

typealias completion = () -> Void
import AVFoundation
class GetSetGoView: UIView {

    @IBOutlet weak var textLabel:UILabel!
    override func awakeFromNib() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:Bundle.main.path(forResource: "BeepTone", ofType: "wav")!))
            audioPlayer.numberOfLoops = 0
            audioPlayer.prepareToPlay()
        }
        catch{
            print(error)
        }
        

    }
    func animateOpening(_ string:String? = "READY??",completion: @escaping completion) {
        self.textLabel.text = string
        audioPlayer.play()
        self.animateLabel { (done) in
            if string == "SET" {
                self.animateOpening("GO!!",completion: completion)
            }else if string == "READY??" {
                self.animateOpening("SET",completion: completion)
            }else {
                audioPlayer.stop()
                self.removeFromSuperview()
                completion()
            }
        }
    }
    
    private func animateLabel(withCompletion completion: @escaping (Bool) -> Void) {
        
        self.textLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.75, animations: {
            self.textLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: completion)
    }
}
