//
//  AppDelegate.swift
//  appname
//
//  Created by Matteo Crippa on 12/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Crashlytics
import Fabric
import SwiftyBeaver
import SwiftyJSON
import UIKit

var awesomeJSON: JSON?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        #if DEBUG
        log.addDestination(ConsoleDestination())
        #else
        #endif

        // white status bar
        UIApplication.sharedApplication()
            .setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)

        // push notifications enabled
        // TODO: remove pushes
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        // crashlytics enabled
        Fabric.with([Crashlytics.self])

        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let initialViewController = storyboard.instantiateInitialViewController()

        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {}

    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {
        // reset badge counter to 0
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {}

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

        // push token retrieved and cleaned
        let token = deviceToken.description.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet).joinWithSeparator("")

        /*let net = Networking()

        net.setPush(token) { (err) in
            if (err != nil) {
                log.error(err)
            }
        }*/

    }

}
