//
//  doctorHome.swift
//  medicoz
//
//  Created by Sachin Sharma on 01/04/23.
//

import SwiftUI
import FirebaseAuth

struct doctorHome: View {
    @Environment (\.dismiss) private var dismiss
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    @State  var selectedTab = 1
    @StateObject var sessionManager = SessionManager()

    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab){
//                doctorHomeView(selectedTab: $selectedTab)
//                    .tabItem {
//                        Image(systemName: "house.fill")
//                        Text("Home")
//                    }
//                    .tag(0)
                doctorAppointmentView()
                    .tabItem {
                        Image(systemName: "calendar.badge.clock")
                        Text("Appointments")
                    }.tag(2)
                appointmentView()
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Appointments")
                    }.tag(3)
                
                
                doctorProfile()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }.tag(4)

            }
            
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
//            .fullScreenCover(isPresented: $sessionManager.doctorDocumentNotFound, onDismiss: nil) {
//                doctorAccountSetup()
//            }
            .onAppear {
                if Auth.auth().currentUser != nil {
                    sessionManager.doctorApiCall()
                }
            }
        }
    }
}

struct doctorHome_Previews: PreviewProvider {
    static var previews: some View {
        doctorHome()
    }
}
