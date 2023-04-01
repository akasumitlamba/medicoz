//
//  medicozApp.swift
//  medicoz
//
//  Created by Sachin Sharma on 06/02/23.
//

import SwiftUI
import FirebaseCore

@main
struct medicozApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let sessionManager = SessionManager()
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
