//
//  Main.swift
//  medicoz
//
//  Created by Sachin Sharma on 01/04/23.
//


//exception in checking role

import SwiftUI

struct Main: View {
    
    @StateObject var sessionManager = SessionManager()
    @Environment (\.dismiss) private var dismiss
    @Environment (\.presentationMode) var presentationMode
    @State var doc = false
    @State var pat = false
    
    var body: some View {
        ZStack {
            if sessionManager.isLoggedIn {
                switch sessionManager.userRole {
                    case .role1:
                        patientHome()
                    case .role2:
                        doctorHome()
                    case nil:
                        Text("Loading...")
                }
            } else {
                NavigationView {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Spacer()
                            HStack {
                                VStack{
                                    Button {
                                        self.pat = true
                                    } label: {
                                        VStack {
                                            Image(systemName: "chevron.left.circle")
                                                .resizable()
                                                .foregroundColor(.blue)
                                                .frame(width: 70, height: 70)
                                                .navigationBarBackButtonHidden(true)
                                                .navigationBarHidden(true)
                                            Text("Patient")
                                                .foregroundColor(.blue)
                                        }
                                    }

                                }.fullScreenCover(isPresented: $doc) {
                                    doctorAuth(sessionManager: SessionManager())
                                }
                                
                                Spacer()
                                
                                VStack{
                                    Button {
                                        self.doc = true
                                    } label: {
                                        VStack {
                                            Image(systemName: "chevron.right.circle")
                                                .resizable()
                                                .foregroundColor(.blue)
                                                .frame(width: 70, height: 70)
                                                .navigationBarBackButtonHidden(true)
                                                .navigationBarHidden(true)
                                            Text("Doctor")
                                                .foregroundColor(.blue)
                                        }
                                    }

                                }.fullScreenCover(isPresented: $pat) {
                                    patientAuth(sessionManager: SessionManager())
                                }
                            }.padding()
                        }
                    }
                }
            }
        }.onAppear() {
            if sessionManager.isLoggedIn {
                if sessionManager.isLoggedIn {
                    sessionManager.fetchUserRole { result in
                        switch result {
                        case .success(let role):
                            // Handle the role that was fetched
                            print("Fetched role: \(role)")
                        case .failure(let error):
                            // Handle the error that occurred
                            print("Error fetching role: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }.edgesIgnoringSafeArea(.all).navigationBarBackButtonHidden(true).navigationBarHidden(true)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}

