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
    var body: some View {
        ZStack {
            TabView{
                PatientHomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                appointmentView()
                    .tabItem {
                        Image(systemName: "calendar.badge.clock")
                        Text("Appointments")
                    }
                medicalHistory()
                    .tabItem {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("History")
                    }
                profileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }.edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }.navigationBarBackButtonHidden(true)
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
