//
//  redirectAuth.swift
//  medicoz
//
//  Created by Sachin Sharma on 14/02/23.
//

import SwiftUI
import Firebase

struct redirectAuth: View {
    
    @StateObject var sessionManager = SessionManager()
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            
            if sessionManager.isLoading {
                // Full screen loader here
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }
            }
            else {
                VStack{
                    
                    if sessionManager.userRole == .role1 {
                        if sessionManager.patientDocumentFound {
                            patientHome()
                        } else {
                            patientAccountSetup()
                        }
                    } else if sessionManager.userRole == .role2 {
                        if sessionManager.doctorDocumentFound {
                            doctorHome()
                        } else {
                            doctorAccountSetup()
                        }
                    }
                }
            }
                
        }.onAppear {
            // Show loader when view appears
            sessionManager.isLoading = true
            
            if sessionManager.userRole == .role1 {
                sessionManager.patientApiCall()
            } else if sessionManager.userRole == .role2 {
                sessionManager.doctorApiCall()
            }
            // Simulate loading time
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                sessionManager.isLoading = false
            }
        }.edgesIgnoringSafeArea(.all).navigationBarBackButtonHidden(true).navigationBarHidden(true)
    }
}



struct redirectAuth_Previews: PreviewProvider {
    static var previews: some View {
        redirectAuth()
    }
}
