//
//  doctorProfile.swift
//  medicoz
//
//  Created by Sachin Sharma on 02/04/23.
//

import SwiftUI
import FirebaseAuth

struct doctorProfile: View {
    @StateObject var sessionManager = SessionManager()
    @AppStorage ("uid") var userID: String = ""
    @AppStorage ("userRole") var userRole: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            sessionManager.userRole = nil
                            sessionManager.isLoggedIn = false
                            print("Signed Out Successfully!")
                            withAnimation {
                                userID = ""
                                userRole = ""
                            }
                            
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

struct doctorProfile_Previews: PreviewProvider {
    static var previews: some View {
        doctorProfile()
    }
}
