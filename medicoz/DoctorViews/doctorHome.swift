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
    var body: some View {
        ZStack {
            VStack {
                Text("Doctor Home")
                VStack{
                    Button {
                        //TODO: Signout here
                        do {
                            try Auth.auth().signOut()
                            print("Signed Out Successfully!")
                            dismiss()
                        } catch {
                                print("ERROR: Could not sign out!")
                        }
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .frame(height: 35)
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(.bordered)

                        
                    
                }.padding(.top, 30)
            }
        }
        
    }
}

struct doctorHome_Previews: PreviewProvider {
    static var previews: some View {
        doctorHome()
    }
}
