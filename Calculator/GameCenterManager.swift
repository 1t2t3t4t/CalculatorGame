//
//  GameCenterManager.swift
//  Calculator
//
//  Created by marky RE on 9/5/2560 BE.
//  Copyright © 2560 Nathakorn. All rights reserved.
//

import Foundation
import GameKit

class GameCenterManager: NSObject,GKGameCenterControllerDelegate {
    
    static let sharedInstance = GameCenterManager()
    
    var leaderBoard: UIViewController {
        get {
            let gcvc = GKGameCenterViewController()
            gcvc.gameCenterDelegate = self
            return gcvc
        }
    }
    
    class func authPlayer(withCompletion completion: @escaping (UIViewController?, Error?) -> Void){
        GKLocalPlayer.localPlayer().authenticateHandler = {
            (view, error) in
            completion(view,error)
        }
    }
    func saveHighscore(number : Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: Constant.LEADERBOARD_IDENTIFIER)
            scoreReporter.value = Int64(number)
            let scoreArray : [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: { (error) in
                print(error)
            })
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}
