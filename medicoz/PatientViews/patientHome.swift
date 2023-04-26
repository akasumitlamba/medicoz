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
    @StateObject var sessionManager = SessionManager()

    var body: some View {
        ZStack {
            ZStack {
                PatientHomeView()
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
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
