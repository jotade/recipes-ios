//
//  AppDelegate.swift
//  Recipes
//
//  Created by IM Development on 7/8/18.
//  Copyright © 2018 Juan Parra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cdManager = CoreDataManager(modelName: "Recipes")!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        do {
            Network.reachability = try Reachability(hostname: "www.food2fork.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
    }
}

let cdManager = (UIApplication.shared.delegate as! AppDelegate).cdManager
