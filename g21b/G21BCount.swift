//
//  G21BCount.swift
//  g21b
//
//  Created by Maroun Abi Ramia on 9/7/15.
//  Copyright (c) 2015 Maroun Abi Ramia. All rights reserved.
//

import UIKit
import GameKit

class G21BCount: NSObject {
    private var count = Int64(0)
    private var tracker = Int(0)
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    class var sharedInstance: G21BCount{
        struct Singleton{
            static let instance = G21BCount()
        }
        return Singleton.instance
    }
    
    override init(){
        super.init()
    }
    
    func loadTheCount() -> Int64{
    
        if defaults.integerForKey(COUNT_KEY) >= 0{
            count = Int64(defaults.integerForKey(COUNT_KEY))
        }else{
            count = 0
            defaults.setInteger(Int(count), forKey: COUNT_KEY)
            defaults.synchronize()
        }
            
        return count
    }
    
    func incrementCount() -> Int64{
        tracker++
        return ++count
    }
    
    func incrementCountBy( incr: Int64){
        count += incr;
        tracker += Int(incr)
        saveCount()
        NSNotificationCenter.defaultCenter().postNotificationName(COUNT_NOTIF_UPDATE, object: self)
    }
    
    func currentCountTrack() -> Int{
        return tracker;
    }
    
    func zeroOutTracker(){
        tracker = 0
    }
    
    func getCount() -> Int64{
        return count
    }
    
    func saveCount(){
        defaults.setInteger(Int(count), forKey: COUNT_KEY)
        defaults.synchronize()
    }
    
    func setCount(c: Int64){
        count = c
    }
}


/*
 *       Leaderboard Extension:
 *                               showGameCenterLeaderboards()
 *                               actionReportScoreLeaderboard()
 *
*/

extension G21BCount{
    func showGameCenterLeaderboards() {
        actionReportScoreLeaderboard()
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "g21b") { (isShow) -> Void in
            print("\n[MainViewController] Game Center Leaderboards Is show\n")
        }
    }
    
    func actionReportScoreLeaderboard() {
        saveCount()
        EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: "g21b", score: Int(loadTheCount()))
        print("\n[LeaderboardsActions] Score send to Game Center \(EasyGameCenter.isPlayerIdentifiedToGameCenter())")
        
    }
    
    func setRankLabels( topRank: UILabel, myRank: UILabel){
        setTopRankLabel(topRank)
        setSelfRankLabel(myRank)
    }
    
    private func setTopRankLabel(label: UILabel){
        let gkProperties = GKLeaderboard()
        gkProperties.range = NSMakeRange(1, 1)
        gkProperties.playerScope = GKLeaderboardPlayerScope.Global
        gkProperties.timeScope = GKLeaderboardTimeScope.AllTime
        gkProperties.identifier = "g21b"
        gkProperties.loadScoresWithCompletionHandler { (resultGKScore, error) -> Void in
            if ((error) != nil){
                print("Error getting top player")
            }else{
                if let playerObjects = resultGKScore {
                    for playerProperties in playerObjects as [GKScore] {
                        label.text = "\(playerProperties.player.alias!): \(playerProperties.value) 🏆"
                    }
                }
            }
        }
    }
    
    private func setSelfRankLabel(label: UILabel!){
        EasyGameCenter.getHighScore(leaderboardIdentifier: "g21b") {
            (tupleHighScore) -> Void in
            if let tupleIsOk = tupleHighScore {
                label.text = "\(tupleIsOk.playerName) #\(tupleIsOk.rank)"
                if (Int(self.count) < tupleIsOk.score){
                    self.count = Int64(tupleIsOk.score);
                    NSNotificationCenter.defaultCenter().postNotificationName(COUNT_NOTIF_UPDATE, object: self)
                }
                self.saveCount();
            }
        }
    }
}


/*
 *   Achievement Extension:
 *                           Keep track achievement level
 *                           Award user if achieved
 *                           Check achievements for previous users
*/
extension G21BCount{
    func checkAchievements(){
        checkInitialAchievement()
        checkRestOfAchievements()
    }
    
    func reportAchievement( idV: Int) -> Bool{
        var result = false
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() && !EasyGameCenter.isAchievementCompleted(achievementIdentifier: "G21B.\(idV)") {
            EasyGameCenter.reportAchievement(progress: Double(count), achievementIdentifier: "G21B.\(idV)", showBannnerIfCompleted: true)
            result = true
        }
        return result
    }
    
    private func checkInitialAchievement(){
        if NSUserDefaults.standardUserDefaults().boolForKey("InitialLogin") != true{
                if reportAchievement(AchievementIds.INITIAL_LOGIN.rawValue) {
                    incrementCountBy(100)
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "InitialLogin")
                }
            }
        }
    
    func reportSharedSocialMediaAchievements( mediaType: Int ){
        if reportAchievement(mediaType) {
            incrementCountBy(1000)
        }
    }
    
    private func checkRestOfAchievements(){
        if ( Int(count) >= 500000 ){
            reportAchievement(AchievementIds.FIVE_HUNDRED_THOUSAND.rawValue)
        }else if (Int(count) >= 1000000 ){
            reportAchievement(AchievementIds.ONE_MIL.rawValue)
        }else if (Int(count) >= 10000000 ){
            reportAchievement(AchievementIds.TEN_MIL.rawValue)
        }else if (Int(count) >= 500000000){
            reportAchievement(AchievementIds.FIVE_HUNDRED_MIL.rawValue)
        }else if (Int(count) >= 1000000000 ){
            reportAchievement(AchievementIds.ONE_BIL.rawValue)
        }
    }
}