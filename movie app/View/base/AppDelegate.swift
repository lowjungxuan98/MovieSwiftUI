//
//  AppDelegate.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    static private(set) var instance: AppDelegate! = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        AppDelegate.instance = self
        FirebaseApp.configure()
        AuthenticationManager.shared.isRequired = true
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

    }
}
