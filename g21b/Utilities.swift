//
//  Utilities.swift
//  g21b
//
//  Created by Maroun Abi Ramia on 10/20/15.
//  Copyright © 2015 Maroun Abi Ramia. All rights reserved.
//

import UIKit
import Social

class Utilities: NSObject {
    
    override init(){}
    
    func rateApp(){
        
        let url  = NSURL(string: "\(APP_URL)")
        if UIApplication.sharedApplication().canOpenURL(url!) == true  {
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    func shareAction(count: Int, view: UIViewController) {
        
        var sharingItems = [AnyObject]()
        let sharingText: String! = "My score is \(count)"
        let sharingImage = UIImage(named: "Icon-Small.png")
        let sharingURL: String! = APP_URL
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        view.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func showSettings(viewInstance: UIViewController, count: Int){
        let alert = UIAlertController(title: "Settings", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
        let rate = UIAlertAction(title: "Review this app", style: .Default) { (action) in
           self.rateApp()
        }
        
        let share = UIAlertAction(title: "Other", style: .Default) { (action) in
            self.shareAction( count, view: viewInstance )
        }
        
        let shareFacebook = UIAlertAction(title: "Share Facebook", style: .Default) { (action) in
            self.facebookButtonPushed(viewInstance)
        }
        
        let shareTwitter = UIAlertAction(title: "Share Twitter", style: .Default) { (action) in
            self.twitterButtonPushed(viewInstance)
        }
        
        alert.addAction(rate)
        alert.addAction(cancelAction)
        alert.addAction(shareFacebook)
        alert.addAction(shareTwitter)
        alert.addAction(share)
        viewInstance.presentViewController(alert, animated: true, completion: nil)
    }
    
    func twitterButtonPushed( vc: UIViewController) {
        let count = G21BCount.sharedInstance
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Download get to 1 billion and try to beat my score \(count.getCount()) \(APP_URL)")
            twitterSheet.addURL(NSURL(string: "\(APP_URL)"))
            twitterSheet.completionHandler = {
                result -> Void in
                
                let getResult = result as SLComposeViewControllerResult;
                switch(getResult.rawValue) {
                    
                    case SLComposeViewControllerResult.Cancelled.rawValue:
                        print("Cancelled")
                    
                    case SLComposeViewControllerResult.Done.rawValue:
                        count.reportSharedSocialMediaAchievements(AchievementIds.TWITTER.rawValue)
                    default: print("Error!")
                }
            }
            
            vc.presentViewController(twitterSheet, animated: true, completion:nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            vc.presentViewController(alert, animated: true, completion:nil)
        }
    }
    
    
    func facebookButtonPushed( vc: UIViewController) {
        let count = G21BCount.sharedInstance

        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let fb:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fb.setInitialText("Download get to 1 billion and try to beat my score \(count.getCount())")
            fb.addURL(NSURL(string: "\(APP_URL)"))
            fb.completionHandler = {
                result -> Void in
                
                let getResult = result as SLComposeViewControllerResult;
                switch(getResult.rawValue) {
                    case SLComposeViewControllerResult.Cancelled.rawValue:
                        print("Cancelled")
                    case SLComposeViewControllerResult.Done.rawValue:
                        count.reportSharedSocialMediaAchievements(AchievementIds.FACEBOOK.rawValue)
                        print("It's Work!")
                    
                    default: print("Error!")
                }
            }
            
            vc.presentViewController(fb, animated: true, completion:nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            vc.presentViewController(alert, animated: true, completion:nil)
        }
    }
}
