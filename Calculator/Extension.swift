//
//  Extension.swift
//  Calculator
//
//  Created by Nathakorn on 7/31/17.
//  Copyright © 2017 Nathakorn. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func instantiateViewController() -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: self))
    }
    
    func showError(withMessage message:String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    
    static func +=(lhs: inout String?,rhs:String) {
        guard lhs != nil else {
            lhs = rhs
            return
        }
        lhs = lhs!+rhs
    }
    
    static postfix func --(lhs: inout String) {
        lhs = lhs.substring(to: lhs.index(lhs.endIndex, offsetBy: -1))
    }
    
    static func +(lhs:String,rhs:String) -> String{
        return "\(lhs)\(rhs)"
    }
    
    mutating func popLast() {
        guard self != "" else {
            return
        }
        self--
    }
}

func randomInt(num:Int) -> Int {
    return Int(arc4random_uniform(UInt32(num))) + 1
}

extension UIView {
    class var view: UIView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?[0] as! UIView
    }
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UserDefaults {
    
    class func saveScore(value:Int,key:String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func loadScore(key:String) -> Int? {
        if UserDefaults.standard.value(forKey: key) != nil {
        let ans = UserDefaults.standard.value(forKey: key) as! Int
        return ans
        }
        else {
            return nil
        }
    }
}




