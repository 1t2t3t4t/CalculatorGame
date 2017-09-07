//
//  RateMyApp.swift
//  RateMyApp
//
//  Created by Jimmy Jose on 08/09/14.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit


class RemindUser : UIViewController,UIAlertViewDelegate{
    
    fileprivate let kTrackingAppVersion     = "kRemindUser_TrackingAppVersion"
    fileprivate let kFirstUseDate			= "kRemindUser_FirstUseDate"
    fileprivate let kAppUseCount			= "kRemindUser_AppUseCount"
    fileprivate let kSpecialEventCount		= "kRemindUser_SpecialEventCount"
    fileprivate let kDidRateVersion         = "kRemindUser_DidRateVersion"
    fileprivate let kDeclinedToRate			= "kRemindUser_DeclinedToRate"
    fileprivate let kRemindLater            = "kRemindUser_RemindLater"
    fileprivate let kRemindLaterPressedDate	= "kRemindUser_RemindLaterPressedDate"
    
    fileprivate var reviewURL = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id="
    fileprivate var reviewURLiOS7 = "itms-apps://itunes.apple.com/app/id"
    
    
    var promptAfterDays:Double = 30
    var promptAfterUses = 2
    var promptAfterCustomEventsCount = 10
    var daysBeforeReminding:Double = 1
    
    var alertTitle = NSLocalizedString("Rate the app", comment: "RateMyApp")
    var alertMessage = ""
    var alertOKTitle = NSLocalizedString("Rate Now", comment: "RateMyApp")
    var alertRemindLaterTitle = NSLocalizedString("Not Now", comment: "RateMyApp")
    var appID = ""
    
    var debug = false
    
    class var sharedInstance : RateMyApp {
        struct Static {
            static let instance : RateMyApp = RateMyApp()
        }
        return Static.instance
    }
    
    
    //    private override init(){
    //
    //        super.init()
    //
    //    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    fileprivate func initAllSettings(){
        
        let prefs = UserDefaults.standard
        
        prefs.set(getCurrentAppVersion(), forKey: kTrackingAppVersion)
        prefs.set(Date(), forKey: kFirstUseDate)
        prefs.set(1, forKey: kAppUseCount)
        prefs.set(0, forKey: kSpecialEventCount)
        prefs.set(false, forKey: kDidRateVersion)
        prefs.set(false, forKey: kDeclinedToRate)
        prefs.set(false, forKey: kRemindLater)
        
    }
    
    func trackEventUsage(){
        
        incrementValueForKey(name: kSpecialEventCount)
        
    }
    
    func trackAppUsage(){
        
        incrementValueForKey(name: kAppUseCount)
        
    }
    
    fileprivate func isFirstTime()->Bool{
        
        let prefs = UserDefaults.standard
        
        let trackingAppVersion = prefs.object(forKey: kTrackingAppVersion) as? NSString
        
        if((trackingAppVersion == nil) || !(getCurrentAppVersion().isEqual(to: trackingAppVersion! as String)))
        {
            return true
        }
        
        return false
        
    }
    
    fileprivate func incrementValueForKey(name:String){
        
        if(appID.characters.count == 0)
        {
            fatalError("Set iTunes connect appID to proceed, you may enter some random string for testing purpose. See line number 59")
        }
        
        if(isFirstTime())
        {
            initAllSettings()
            
        }
        else
        {
            let prefs = UserDefaults.standard
            let currentCount = prefs.integer(forKey: name)
            prefs.set(currentCount+1, forKey: name)
            
        }
        
        if(shouldShowAlert())
        {
            showRatingAlert()
        }
        
    }
    
    fileprivate func shouldShowAlert() -> Bool{
        
        if debug {
            return true
        }
        
        let prefs = UserDefaults.standard
        
        let usageCount = prefs.integer(forKey: kAppUseCount)
        let eventsCount = prefs.integer(forKey: kSpecialEventCount)
        
        let firstUse = prefs.object(forKey: kFirstUseDate) as! Date
        
        let timeInterval = Date().timeIntervalSince(firstUse)
        
        let daysCount = ((timeInterval / 3600) / 24)
        
        let hasRatedCurrentVersion = prefs.bool(forKey: kDidRateVersion)
        
        let hasDeclinedToRate = prefs.bool(forKey: kDeclinedToRate)
        
        let hasChosenRemindLater = prefs.bool(forKey: kRemindLater)
        
        if(hasDeclinedToRate)
        {
            return false
        }
        
        if(hasRatedCurrentVersion)
        {
            return false
        }
        
        if(hasChosenRemindLater)
        {
            let remindLaterDate = prefs.object(forKey: kRemindLaterPressedDate) as! Date
            
            let timeInterval = Date().timeIntervalSince(remindLaterDate)
            
            let remindLaterDaysCount = ((timeInterval / 3600) / 24)
            
            return (remindLaterDaysCount >= daysBeforeReminding)
        }
        
        if(usageCount >= promptAfterUses)
        {
            return true
        }
        
        if(daysCount >= promptAfterDays)
        {
            return true
        }
        
        if(eventsCount >= promptAfterCustomEventsCount)
        {
            return true
        }
        
        return false
        
    }
    
    
    fileprivate func showRatingAlert(){
        let infoDocs : NSDictionary = Bundle.main.infoDictionary! as NSDictionary
        let appname : NSString = infoDocs.object(forKey: "CFBundleName") as! NSString
        
        var message = NSLocalizedString("If you found 60:60 fun!\n please take a moment to rate it", comment: "RateMyApp") //%@
        message = String(format:message, appname)
        
        if(alertMessage.characters.count == 0)
        {
            alertMessage = message
        }
        
        
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            
            let rate = UIAlertAction(title: alertOKTitle, style:.default, handler: { alertAction in
                self.okButtonPressed()
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(rate)
            alert.addAction(UIAlertAction(title: alertRemindLaterTitle, style:.cancel, handler: { alertAction in
                self.remindLaterButtonPressed()
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.preferredAction = rate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let controller = appDelegate.window?.rootViewController
            DispatchQueue.main.async {
                controller?.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertView()
            alert.title = alertTitle
            alert.message = alertMessage
            alert.addButton(withTitle: alertRemindLaterTitle)
            alert.addButton(withTitle: alertOKTitle)
            alert.delegate = self
            alert.show()
        }
        
        
    }
    internal func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        
        if(buttonIndex == 0)
        {
            cancelButtonPressed()
        }
        else if(buttonIndex == 1)
        {
            remindLaterButtonPressed()
        }
        else if(buttonIndex == 2)
        {
            okButtonPressed()
        }
        
        alertView.dismiss(withClickedButtonIndex: buttonIndex, animated: true)
        
    }
    
    fileprivate func deviceOSVersion() -> Float{
        
        let device : UIDevice = UIDevice.current;
        let systemVersion = device.systemVersion;
        let iOSVerion : Float = (systemVersion as NSString).floatValue
        
        return iOSVerion
    }
    
    fileprivate func hasOS8()->Bool{
        
        if(deviceOSVersion() < 8.0)
        {
            return false
        }
        
        return true
        
    }
    
    func okButtonPressed(){
        
        UserDefaults.standard.set(true, forKey: kDidRateVersion)
        let appStoreURL = URL(string:reviewURLiOS7+appID)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appStoreURL!, options:[:], completionHandler: { (success) in
                if success {
                    print("rate")
                }
                else{
                    print("rate error")
                }
            })
        } else {
            if UIApplication.shared.canOpenURL(appStoreURL!) {
                UIApplication.shared.openURL(appStoreURL!)
            }
        }
        
    }
    
    fileprivate func cancelButtonPressed(){
        
        UserDefaults.standard.set(true, forKey: kDeclinedToRate)
        
    }
    
    fileprivate func remindLaterButtonPressed(){
        
        UserDefaults.standard.set(true, forKey: kRemindLater)
        UserDefaults.standard.set(Date(), forKey: kRemindLaterPressedDate)
        
    }
    
    fileprivate func getCurrentAppVersion()->NSString{
        
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! NSString)
        
    }
    
    
    
}
