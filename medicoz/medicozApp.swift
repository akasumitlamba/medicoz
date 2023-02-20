//
//  medicozApp.swift
//  medicoz
//
//  Created by Sachin Sharma on 06/02/23.
//

import SwiftUI
import FirebaseCore

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//content_copy
//
//    return true
//  }
//}



@main


struct medicozApp: App {
    // register app delegate for Firebase setup
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
