//
//  AppDelegate.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 20.09.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(Realm.Configuration.defaultConfiguration.fileURL)

        // each expression that can throw an error needs to be in a do catch block
        // and have the try keyword
        do {
            _ = try Realm() // variable _ because we do not use it
        } catch {
            print("Error initializing Realm, \(error)")
        }
        
        return true
    }

}

