//
//  userSession.swift
//  medicoz
//
//  Created by Sachin Sharma on 30/01/23.
//

import Foundation

class UserSession: ObservableObject {
    
    @Published var isLoggedIn : Bool {
        didSet{
            UserDefaults.standard.set(isLoggedIn, forKey: "Login")
        }
    }
    init() {
        self.isLoggedIn = false
    }
}
