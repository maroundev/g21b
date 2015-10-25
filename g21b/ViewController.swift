//
//  ViewController.swift
//  g21b
//
//  Created by Maroun Abi Ramia on 9/7/15.
//  Copyright (c) 2015 Maroun Abi Ramia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GADBannerViewDelegate, EasyGameCenterDelegate {
    var count = G21BCount.sharedInstance
    var ad: GADBannerView!
    var util = Utilities()
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var topRankLabel: UILabel!
    var label: UILabel!

    @IBOutlet weak var countBtn: UIButton!
    @IBAction func count(sender: AnyObject) {
        self.countLabel.text = "\(self.count.incrementCount())"
        labelAffect()
    }

    
    @IBAction func showGameCenter(sender: AnyObject) {
        count.showGameCenterLeaderboards()
    }
    @IBAction func settings(sender: AnyObject) {
        util.showSettings(self, count: Int(count.getCount()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoBtn.hidden = true
        EasyGameCenter.sharedInstance(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        EasyGameCenter.delegate = self
        countLabel.text = "\(count.loadTheCount())"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCountLabel:", name:COUNT_NOTIF_UPDATE, object: nil)
        createAdd()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        count.saveCount()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        ad.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ad.removeFromSuperview()
    }

    
    /********************************************************************************************************************/
    
    // MARK: GOOGLE ADS
    
    /********************************************************************************************************************/

    func createAdd(){
        ad = GADBannerView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.size.width, height: 50))
        ad.delegate = self
        ad.adUnitID = "ca-app-pub-5238743433535049/2950508813"
        ad.rootViewController = self
        
        let req = GADRequest()
        ad.loadRequest(req)
        self.view.addSubview(ad)
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        ad.removeFromSuperview()
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: { () -> Void in
            self.ad.frame = CGRect(x: 0, y: self.view.frame.height-50, width: self.view.frame.size.width, height: 50)
        })
    }
    
    /********************************************************************************************************************/

    // MARK: GAMECENTER DELEGATES
    
    /********************************************************************************************************************/

    func easyGameCenterAuthentified() {
        infoBtn.hidden = false
        print("\n[MainViewController] Player Authentified\n")
    }
  
    func easyGameCenterNotAuthentified() {
        let alert = UIAlertController(title: "Play not signed in", message: "Sign in to game center to view leaderboards", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        print("\n[MainViewController] Player not authentified\n")

    }

    func easyGameCenterInCache() {
        count.setRankLabels(topRankLabel, myRank: rankLabel)
        count.checkAchievements()
        print("\n[MainViewController] GkAchievement & GKAchievementDescription in cache\n")
    }
    
    
    func updateCountLabel(notification: NSNotification){
        countLabel.text = String(count.loadTheCount())
        labelAffect()
    }
    
    func labelAffect(){
        if( label != nil ){ label.removeFromSuperview() }
        label = UILabel(frame: CGRectMake(self.countLabel.frame.width/1.5, self.countLabel.frame.height, 100, 100))
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.greenColor()
        label.font = UIFont.boldSystemFontOfSize(16)
        label.text = "+\(count.currentCountTrack())"
        self.view.addSubview(label)
        
        UIView.animateWithDuration(0.6) { () -> Void in
            self.label.alpha = 0
        }
    }
}

