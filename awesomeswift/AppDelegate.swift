//
//  AppDelegate.swift
//  awesomeswift
//
//  Created by Matteo Crippa on 24/01/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Alamofire
import Crashlytics
import Fabric
import Log
import RealmSwift
import UIKit

// swiftlint:disable force_try
let realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let pushEndpoint = "http://matteocrippa.it/awesomeswift/push.php"

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        #if DEBUG
            Log.enabled = true
            Log.minLevel = .Trace
        #else
            Log.enabled = false
        #endif

        // force purge realm
        if NSUserDefaults.standardUserDefaults().objectForKey("realmResetv5") == nil {
            // swiftlint:disable force_try
            try! realm.write() {
                realm.deleteAll()
            }
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "realmResetv5")
            NSUserDefaults.standardUserDefaults().synchronize()
            Log.debug("Realm reset")
        }

        // force status bar text color to white
        UIApplication.sharedApplication().setStatusBarStyle(
            UIStatusBarStyle.LightContent,
            animated: true
        )

        // init push notification
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        // setup crahslytics
        Fabric.with([Crashlytics.self])

        return true
    }

    func applicationWillResignActive(application: UIApplication) {}

    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {}

    // PRAGMA - Push notification
    func application(
        application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

        let token = deviceToken.description.componentsSeparatedByCharactersInSet(
            NSCharacterSet
                .alphanumericCharacterSet()
                .invertedSet)
            .joinWithSeparator("")


        Alamofire.request(.GET, pushEndpoint, parameters: ["token": token])
            .responseJSON { response in
                print(response)
        }

    }

}
