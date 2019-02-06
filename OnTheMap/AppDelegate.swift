//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 1/18/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userKey: String? = nil
    var sessionID: String? = nil
    var studentLocations: [StudentLocation] = []
    var newStudentLocation = [String:Any]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

