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
    @ObservedObject private var viewModel = DataManager()
    
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
                        VStack {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(3).padding(20)
                            Text("Wait and take a Sip of Tea")
                                .font(.title3)
                        }
                    }
                }
                else {
                    if userRole == "patient" {
                        patientHome()
                    } else {
                        doctorHome()
                    }
                }
            }
            .onAppear {
                // Show loader when view appears
                sessionManager.isLoading = true
                if Auth.auth().currentUser != nil {
                    sessionManager.isLoggedIn = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        sessionManager.isLoading = false
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

