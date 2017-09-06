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
    func asImage(boundsValue:CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds:boundsValue)
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
    class func setPurchase(value:Bool,key:String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func checkPurchase(key:String) -> Bool? {
        if UserDefaults.standard.value(forKey: key) != nil {
            return true
        }
        else {
            return nil
        }
    }
    class func setMute(value:Bool,key:String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func checkMute(key:String) -> Bool {
        if UserDefaults.standard.value(forKey: key) != nil {
            let ans = UserDefaults.standard.value(forKey: key) as! Bool
            return ans
        }
        else {
            return false
        }
    }
}

extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

extension UIFont {
    class func font_autoAdjust(_ size : CGFloat) -> UIFont {
        return UIFont(name: "Digital-7", size: size)!
    }
}

extension UIDevice {
    enum DeviceTypes {
        case iPhone4_4s
        case iPhone5_5s
        case iPhone7_7s
        case iPhone7p_7ps
        case after_iPhone7p_7ps
    }
    
    static var deviceType : DeviceTypes {
        print("yo ip \(UIScreen.main.bounds.height)")
        switch UIScreen.main.bounds.height {
            
        case 480.0:
            return .iPhone4_4s
        case 568.0:
            return .iPhone5_5s
        case 667.0:
            print("yo ip7")
            return .iPhone7_7s
        case 736.0:
            return .iPhone7p_7ps
        default:
            return .after_iPhone7p_7ps
        }
    }
    
    
    
    // for ipad pro 10.5 device
    public static var isPadPro105: Bool {
        if UIScreen.main.nativeBounds.size.height == 960 {
            return true
        }
        return false
    }
}

extension Int{
    
    var fontSize : CGFloat {
        
        var deltaSize : CGFloat = 0;
        switch (UIDevice.deviceType) {
        case .iPhone4_4s,
             .iPhone5_5s :
            deltaSize = -6
            break
        case .iPhone7_7s :
            deltaSize = 0
            break
        case .iPhone7p_7ps :
            deltaSize = 0
            break
        default:
            deltaSize = 0
            break
        }
        
        let selfValue = self;
        return CGFloat(selfValue) + deltaSize;
    }
}

