//
//  Constant.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
var launchedShortcutItem: UIApplicationShortcutItem?

struct Constant {
    
    static let DIFFICULTY_SELECTION = "DifficultySelection"
    static let SHOW_PROBLEM = "showProblem"
    static let SHOW_TWO_PLAYERS = "showTwoPlayers"
    static let SHOW_MORE = "showMore"
    
    static let READY = "READY??"
    static let SET = "SET"
    static let GO = "GO"
}
enum ShortcutIdentifier:String {
    case onePlayer
    case twoPlayer
    init?(fullType: String) {
        guard let last = fullType.components(separatedBy: ".").last else { return nil }
        self.init(rawValue: last)
    }
    var type: String {
        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
    }
    
}

var audioPlayer = AVAudioPlayer()
