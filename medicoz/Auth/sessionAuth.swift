//
//  sessionAuth.swift
//  medicoz
//
//  Created by Sachin Sharma on 02/04/23.
//

import SwiftUI
import FirebaseAuth

struct sessionAuth: View {
    @StateObject var sessionManager = SessionManager()
    @State private var currentViewShowing: String = "patient" // login or signup
    @AppStorage ("userRole") var userRole: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                if currentViewShowing == "patient" {
                    patientAuth(currentShowingView: $currentViewShowing, sessionManager: SessionManager())
                        .transition(.move(edge: .bottom))
                } else {
                    doctorAuth(currentShowingView: $currentViewShowing, sessionManager: SessionManager())
                        .transition(.move(edge: .bottom))
                }
            }
            
            .sheet(isPresented: $sessionManager.navTitleSheet) {
                ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Select Your Role")
                                .foregroundColor(.black)
                            .font(.title2)
                        }.padding().padding(.top)
                        
                        VStack {
                            VStack {
                                Button {
                                    sessionManager.doc = true
                                    sessionManager.pat = false
                                    sessionManager.navTitleSheet = false
                                    sessionManager.showView = false
                                } label: {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Doctor")
                                                .foregroundColor(Color("darkText"))
                                                .font(.title)
                                            Spacer()
                                            Image(systemName: sessionManager.doc ? "checkmark.circle.fill" : "arrow.right")
                                                .resizable()
                                                .foregroundColor(Color("darkText"))
                                                .frame(width: 25, height: 25)
                                                .padding(.trailing)
                                            
                                        }.padding(.horizontal)
                                        
                                        Text("Login yourself as Doctor")
                                            .padding(.horizontal)
                                        
                                    }.padding()
                                        
                                }
                            }
                            Divider()
                            VStack {
                                Button {
                                    sessionManager.pat = true
                                    sessionManager.doc = false
                                    sessionManager.navTitleSheet = false
                                    sessionManager.showView = true
                                } label: {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Patient")
                                                .foregroundColor(Color("darkText"))
                                                .font(.title)
                                            Spacer()
                                            Image(systemName: sessionManager.pat ? "checkmark.circle.fill" : "arrow.right")
                                                .resizable()
                                                .foregroundColor(Color("darkText"))
                                                .frame(width: 25, height: 25)
                                                .padding(.trailing)
                                        }.padding(.horizontal)
                                        
                                        Text("Login Yourself as Patient")
                                            .padding(.horizontal)
                                        
                                    }.padding()
                                }

                            }
                        }

                        
                    }
                    .presentationDetents([.fraction(0.40)])
                }
            }

        }
    }
}

struct sessionAuth_Previews: PreviewProvider {
    static var previews: some View {
        sessionAuth()
    }
}
