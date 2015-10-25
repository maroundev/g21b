//
//  LocalNotificationSchedular.swift
//  g21b
//
//  Created by Maroun Abi Ramia on 10/24/15.
//  Copyright © 2015 Maroun Abi Ramia. All rights reserved.
//

import UIKit

class LocalNotificationSchedular: NSObject {
    func scheduleEveryWeekNotification(){
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "g21b"
        localNotification.alertBody = "Players are catching up!"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 604800)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
}
