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

    func playSound() {
        do {
        audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:Bundle.main.path(forResource: "BeepTone", ofType: "wav")!))
        audioPlayer.numberOfLoops = 0
        audioPlayer.prepareToPlay()
        print("enter nig \(UserDefaults.checkMute(key: "mute"))")
        if UserDefaults.checkMute(key: "mute") {
            print("enter getsetgoview audio mute")
            audioPlayer.volume = 0.0
        }
        }
        catch {
            print(error)
        }

    }
    
    func animateOpening(_ string:String? = "READY??", completion: @escaping completion) {
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
    
    func customAnimate(_ string:String, completion: completion? = nil) {
        self.textLabel.text = string
        self.animateLabel(0.7, withCompletion: {(done) in
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
