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
            doctorHomeView()
            
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            
        }
    }
}

struct doctorHome_Previews: PreviewProvider {
    static var previews: some View {
        doctorHome()
    }
}
