//
//  patientAuth.swift
//  medicoz
//
//  Created by Sachin Sharma on 01/04/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct patientAuth: View {
    
    enum Field {
        case email, password
    }
    
    @State private var isLoginMode = true
    
    @State private var email = ""
    @State private var password = ""
    @State private var role: String = "patient"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var path = NavigationPath ()
    @FocusState private var focusField: Field?
    @State var accountSetup = false
    
    @Binding var currentShowingView: String
    @AppStorage ("userRole") var userRole: String = ""
    
    
    @State var isLoading = false
    @ObservedObject var sessionManager: SessionManager
    @Environment (\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationStack(path: $path){
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack {
                    VStack {
                        Button {
                            sessionManager.navTitleSheet = true
                        } label: {
                            Text("Patient")
                                .frame(alignment: .leading)
                                .clipped()
                                .font(.title)
                                .foregroundColor(Color("lightText"))
                            
                        }
                        
                        Divider()
                        
                    }.padding(.top, 45)
                    
                    VStack {
                        
                        //Image
                        VStack {
                            Image("p2")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 356, height: 229)
                                .clipped()
                                .shadow(radius: 5, x: 5, y: 5)
                                .padding()
                                .padding(.top, 40)
                                .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.15), radius: 18, x: 0, y: 14)
                        }
                        
                        Spacer()
                        
                        //Textfeilds
                        VStack(spacing: 10) {
                            
                            //header
                            HStack {
                                Text(isLoginMode ? "Sign In" : "Sign Up")
                                    .bold()
                                    .font(.title)
                                    .foregroundColor(.black)
                                Spacer()
                            }.padding(.all)
                            
                            //feilds
                            Group {
                                HStack {
                                    Image(systemName: "at")
                                        .symbolRenderingMode(.monochrome)
                                    VStack {
                                        TextField("Email", text: $email)
                                            .padding()
                                            .frame (width: 300, height: 45)
                                            .background (Color.black.opacity (0.05))
                                            .cornerRadius(10)
                                            .keyboardType(.emailAddress)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                            .submitLabel(.next)
                                            .focused($focusField, equals: .email)
                                            .onSubmit {
                                                focusField = .password
                                            }
                                            .onChange(of: email) { _ in
                                                enableButtons()
                                            }
                                    }
                                }
                                .padding(.bottom, 15)
                                
                                HStack {
                                    Image(systemName: "lock")
                                        .symbolRenderingMode(.monochrome)
                                    
                                    VStack{
                                        SecureField("Password", text: $password)
                                            .padding()
                                            .frame (width: 300, height: 45)
                                            .background (Color.black.opacity (0.05))
                                            .cornerRadius(10)
                                            .submitLabel(.done)
                                            .focused($focusField, equals: .password)
                                            .onSubmit {
                                                focusField = nil
                                            }
                                            .onChange(of: password) { _ in
                                                enableButtons()
                                            }
                                    }
                                }
                            }.padding(.bottom, 5)
                            
                        }.padding()
                        
                        //Forgot Password
                        HStack {
                            NavigationLink(destination: forgotPassword()){
                                Spacer()
                                Text("Forgot Password ?")
                                    .padding(.horizontal, 29)
                                    .padding(.bottom, 25)
                                    .foregroundColor(Color.blue)
                            }
                        }
                        
                        //Button
                        VStack {
                            VStack {
                                Button {
                                    
                                    sessionManager.isLoading = true
                                    if isLoginMode {
                                        sessionManager.authenticateUser(email: email, password: password) { result in
                                            switch result {
                                            case .success:
                                                break
                                            case .failure(let error):
                                                alertMessage = error.localizedDescription
                                                showingAlert = true
                                            }
                                        }
                                    }
                                    else {
                                        accountSetup.toggle()
                                    }
                                }
                            label: {
                                Text(isLoginMode ? "Sign In" : "Next")
                                    .fontWeight(.medium)
                                    .frame(width: 300, height: 5)
                            }
                                    .padding(.vertical, 16)
                                    .foregroundColor(Color(.systemBackground))
                                    .background(Color.black)
                                    .cornerRadius(10)
                            }
                            
                            HStack{
                                Text(isLoginMode ? "New to Medicoz?" : "Already a member?")
                                Button {
                                    isLoginMode.toggle()
                                } label: {
                                    Text(isLoginMode ? "Sign Up" : "Sign In")
                                        .foregroundColor(.blue)
                                }
                                
                            }.padding(.top, 20)
                            
                            
                            
                        }
                        Spacer(minLength: 30)
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
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
                                    withAnimation {
                                        self.currentShowingView = "doctor"
                                        sessionManager.navTitleSheet = false
                                    }
                                    
                                } label: {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Doctor")
                                                .foregroundColor(Color("darkText"))
                                                .font(.title)
                                            Spacer()
                                            Image(systemName: "arrow.right")
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
                                    withAnimation {
                                        self.currentShowingView = "patient"
                                        sessionManager.navTitleSheet = false
                                    }
                                    
                                } label: {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Patient")
                                                .foregroundColor(Color("darkText"))
                                                .font(.title)
                                            Spacer()
                                            Image(systemName: "checkmark.circle.fill")
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
            .fullScreenCover(isPresented: $accountSetup) {
                patientAccountSetup(email: $email, password: $password)
            }
            
            
        }.alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    
    func enableButtons() {
        let emailIsGood = email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
}


