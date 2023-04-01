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
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab){
                PatientHomeView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                appointmentView()
                    .tabItem {
                        Image(systemName: "calendar.badge.clock")
                        Text("Appointments")
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
            .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
                imagePicker(image: $image)
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
