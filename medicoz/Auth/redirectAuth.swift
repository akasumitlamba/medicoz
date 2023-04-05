//
//  redirectAuth.swift
//  medicoz
//
//  Created by Sachin Sharma on 14/02/23.
//

import SwiftUI
import Firebase

struct redirectAuth: View {
    
    @AppStorage ("userRole") var userRole: String = ""
    @StateObject var sessionManager = SessionManager()
    @AppStorage ("uid") var userID: String = ""

    //@Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                
                if sessionManager.isLoading {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .edgesIgnoringSafeArea(.all)
                        
                        Color.clear
                            .background(
                                Color.white
                                    .opacity(0.2)
                                    .blur(radius: 10)
                            )
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(3)
                    }
                } else {
                    if userRole == "patient" {
                        if sessionManager.patientDocumentFound {
                            patientHome()
                        } else {
                            patientAccountSetup()
                        }
                    } else {
                        if sessionManager.doctorDocumentFound {
                            doctorHome()
                        } else {
                            doctorAccountSetup()
                        }
                    }
                }
                
                
                
            }
            .onAppear {
                // Show loader when view appears
                sessionManager.isLoading = true
                if Auth.auth().currentUser != nil {
                    sessionManager.isLoggedIn = true
                    if userRole == "patient" {
                        sessionManager.patientApiCall()
                    } else {
                        sessionManager.doctorApiCall()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all).navigationBarBackButtonHidden(true).navigationBarHidden(true)
        }
    }
    
}
    
    struct redirectAuth_Previews: PreviewProvider {
        static var previews: some View {
            redirectAuth()
        }
    }

