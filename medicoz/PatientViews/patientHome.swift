//
//  patientTabView.swift
//  medicoz
//
//  Created by Sachin Sharma on 24/01/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct patientHome: View {
    @Environment (\.dismiss) private var dismiss
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    @State  var selectedTab = 0
    @StateObject var sessionManager = SessionManager()

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab){
                PatientHomeView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                mainMessagesView()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Messages")
                    }.tag(2)
                appointmentView()
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Appointments")
                    }.tag(3)
                
                
                medicalHistory()
                    .tabItem {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("History")
                    }.tag(4)
                profileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }.tag(5)
            }.edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
//            .fullScreenCover(isPresented: $sessionManager.patientDocumentNotFound, onDismiss: nil) {
//                patientAccountSetup()
//            }
            .onAppear {
                if Auth.auth().currentUser != nil {
                    sessionManager.patientApiCall()
                }
            }
        }
    }
}

struct patientHome_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            patientHome()
                .preferredColorScheme(.light)
            patientHome()
                .preferredColorScheme(.dark)
        }
    }
}
