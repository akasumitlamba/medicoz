//
//  Auth.swift
//  medicoz
//
//  Created by Sachin Sharma on 11/02/23.
//

import SwiftUI
import Firebase


struct userAuth: View {
    
    enum Field {
        case email, password
    }
    
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var path = NavigationPath ()
    @FocusState private var focusField: Field?

    @State var isLoading = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
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

                    Spacer(minLength: 50)
                    
                    //Textfeilds
                    VStack(spacing: 10) {
                        
                        //header
                        HStack {
                            Button {
                                isLoginMode = true
                            }label: {
                                Text(isLoginMode ? "Sign In" : "Sign Up")
                                    .bold()
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                            
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
                                if isLoginMode {
                                    autheticateUser()
                                } else {
                                    registerUser()
                                }
                                isLoading.toggle()
                            } label: {
                                Text(isLoginMode ? "Sign In" : "Sign Up")
                                    .fontWeight(.medium)
                                    .frame(width: 300, height: 5)
                            }.buttonStyle(.bordered)
                            .padding(.vertical, 16)
                            .foregroundColor(Color(.systemBackground))
                            .background(Color.black)
                            .cornerRadius(10)
                        }//.disabled(buttonsDisabled)
                        
                        
                        HStack{
                            Text(isLoginMode ? "New to Medicoz?" : "Already a member?")
                            Button {
                                isLoginMode.toggle()
                            } label: {
                                Text(isLoginMode ? "Sign Up" : "Sign In")
                                    .foregroundColor(.blue)
                            }

                        }.padding(.top, 30)
                        
                        
                    }
                    Spacer(minLength: 30)
                    
                }
                .padding(.horizontal)
            }
            .navigationDestination(for: String.self) { view in
                if view == "redirectAuth" {
                    redirectAuth()
                }
            }
            Spacer()
        }.alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            //if already logged in skip to main screen
            if Auth.auth().currentUser != nil {
                print("Login Successfully")
                path.append("redirectAuth")
            }
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    private func autheticateUser(){
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            if let error = error {//login error occured
                print("SignIn Error: \(error.localizedDescription)")
                alertMessage = "SignIn Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Successfully LoggedIn: \(result?.user.uid ?? "")")
                //TODO: load next screen
                path.append("redirectAuth")
            }
        }
    }

    private func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {//login error occured
                print("SignUp Error: \(error.localizedDescription)")
                alertMessage = "SignUp Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Successfully Registered: \(result?.user.uid ?? "")")
                //TODO: load next screen
                path.append("redirectAuth")
            }
        }
    }
}

struct userAuth_Previews: PreviewProvider {
    static var previews: some View {
        userAuth()
    }
}
