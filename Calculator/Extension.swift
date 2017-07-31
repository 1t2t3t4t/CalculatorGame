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
}

extension UIView {
    class var view: UIView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?[0] as! UIView
    }

}
