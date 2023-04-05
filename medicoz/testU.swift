//
//  testU.swift
//  medicoz
//
//  Created by Sachin Sharma on 05/04/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

//struct testU: View {
//
//    enum Field {
//        case email, password
//    }
//
//    @State private var isLoginMode = true
//
//    @State private var email = ""
//    @State private var password = ""
//    @State private var role: String = "doctor"
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    @State private var buttonsDisabled = true
//    @State private var path = NavigationPath ()
//    @FocusState private var focusField: Field?
//
//    @Binding var currentShowingView: String
//    @AppStorage ("userRole") var userRole: String = ""
//
//
//    @State var isLoading = false
//    @ObservedObject var sessionManager: SessionManager
//    @Environment (\.presentationMode) var presentationMode
//
//
//    var body: some View {
//        NavigationView{
//            ZStack {
//                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                    .edgesIgnoringSafeArea(.all)
//
//
//                VStack {
//                    VStack {
//                        Button {
//                            sessionManager.navTitleSheet = true
//                        } label: {
//                            Text("Doctor")
//                                .frame(alignment: .leading)
//                                .clipped()
//                                .font(.title)
//                                .foregroundColor(Color("lightText"))
//
//                        }
//
//                        Divider()
//
//                    }.padding(.top, 45)
//                    VStack {
//
//                        //Image
//                        VStack {
//                            Image("d2")
//                                .renderingMode(.original)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 356, height: 229)
//                                .clipped()
//                                .shadow(radius: 5, x: 5, y: 5)
//                                .padding()
//                                .padding(.top, 40)
//                                .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.15), radius: 18, x: 0, y: 14)
//                        }
//
//                        Spacer()
//
//                        //Textfeilds
//                        VStack(spacing: 10) {
//
//                            //header
//                            HStack {
//                                Button {
//                                    isLoginMode = true
//                                }label: {
//                                    Text(isLoginMode ? "Sign In" : "Sign Up")
//                                        .bold()
//                                        .font(.title)
//                                        .foregroundColor(.black)
//                                }
//                                Spacer()
//                            }.padding(.all)
//
//                            //feilds
//                            Group {
//                                HStack {
//                                    Image(systemName: "at")
//                                        .symbolRenderingMode(.monochrome)
//                                    VStack {
//                                        TextField("Email", text: $email)
//                                            .padding()
//                                            .frame (width: 300, height: 45)
//                                            .background (Color.black.opacity (0.05))
//                                            .cornerRadius(10)
//                                            .keyboardType(.emailAddress)
//                                            .textInputAutocapitalization(.never)
//                                            .autocorrectionDisabled()
//                                            .submitLabel(.next)
//                                            .focused($focusField, equals: .email)
//                                            .onSubmit {
//                                                focusField = .password
//                                            }
//                                            .onChange(of: email) { _ in
//                                                enableButtons()
//                                            }
//                                    }
//                                }
//                                .padding(.bottom, 15)
//
//                                HStack {
//                                    Image(systemName: "lock")
//                                        .symbolRenderingMode(.monochrome)
//
//                                    VStack{
//                                        SecureField("Password", text: $password)
//                                            .padding()
//                                            .frame (width: 300, height: 45)
//                                            .background (Color.black.opacity (0.05))
//                                            .cornerRadius(10)
//                                            .submitLabel(.done)
//                                            .focused($focusField, equals: .password)
//                                            .onSubmit {
//                                                focusField = nil
//                                            }
//                                            .onChange(of: password) { _ in
//                                                enableButtons()
//                                            }
//                                    }
//                                }
//                            }.padding(.bottom, 5)
//
//                        }.padding()
//
//                        //Forgot Password
//                        HStack {
//                            NavigationLink(destination: forgotPassword()){
//                                Spacer()
//                                Text("Forgot Password ?")
//                                    .padding(.horizontal, 29)
//                                    .padding(.bottom, 25)
//                                    .foregroundColor(Color.blue)
//                            }
//                        }
//
//                        //Button
//                        VStack {
//                            VStack {
//                                Button {
//                                    userRole = "doctor"
//                                    sessionManager.isLoading = true
//                                    if isLoginMode {
//                                        sessionManager.authenticateUser(email: email, password: password) { result in
//                                            switch result {
//                                            case .success:
//                                                break
//                                            case .failure(let error):
//                                                alertMessage = error.localizedDescription
//                                                showingAlert = true
//                                            }
//                                        }
//                                    }
//                                    else {
//                                        sessionManager.registerUser(email: email, password: password, role: role) { result in
//                                            switch result {
//                                            case .success:
//                                                break
//                                            case .failure(let error):
//                                                alertMessage = error.localizedDescription
//                                                showingAlert = true
//                                            }
//                                        }
//                                    }
//                                    isLoading.toggle()
//                                }
//                            label: {
//                                Text(isLoginMode ? "Sign In" : "Sign Up")
//                                    .fontWeight(.medium)
//                                    .frame(width: 300, height: 5)
//                            }
//                                    .padding(.vertical, 16)
//                                    .foregroundColor(Color(.systemBackground))
//                                    .background(Color.black)
//                                    .cornerRadius(10)
//                            }
//
//                            HStack{
//                                Text(isLoginMode ? "New to Medicoz?" : "Already a member?")
//                                Button {
//                                    isLoginMode.toggle()
//                                } label: {
//                                    Text(isLoginMode ? "Sign Up" : "Sign In")
//                                        .foregroundColor(.blue)
//                                }
//
//                            }.padding(.top, 20)
//
//                        }
//                        Spacer(minLength: 30)
//
//                    }
//                    .padding(.horizontal)
//                    .padding(.bottom)
//                }
//            }
//
//
//            .sheet(isPresented: $sessionManager.navTitleSheet) {
//                ZStack {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Text("Select Your Role")
//                                .foregroundColor(.black)
//                                .font(.title2)
//                        }.padding().padding(.top)
//
//                        VStack {
//                            VStack {
//                                Button {
//                                    withAnimation {
//                                        self.currentShowingView = "doctor"
//                                        sessionManager.navTitleSheet = false
//                                    }
//
//                                } label: {
//                                    VStack(alignment: .leading) {
//                                        HStack {
//                                            Text("Doctor")
//                                                .foregroundColor(Color("darkText"))
//                                                .font(.title)
//                                            Spacer()
//                                            Image(systemName: "checkmark.circle.fill")
//                                                .resizable()
//                                                .foregroundColor(Color("darkText"))
//                                                .frame(width: 25, height: 25)
//                                                .padding(.trailing)
//
//                                        }.padding(.horizontal)
//
//                                        Text("Login yourself as Doctor")
//                                            .padding(.horizontal)
//
//                                    }.padding()
//
//                                }
//                            }
//                            Divider()
//                            VStack {
//                                Button {
//                                    withAnimation {
//                                        self.currentShowingView = "patient"
//                                        sessionManager.navTitleSheet = false
//                                    }
//
//                                } label: {
//                                    VStack(alignment: .leading) {
//                                        HStack {
//                                            Text("Patient")
//                                                .foregroundColor(Color("darkText"))
//                                                .font(.title)
//                                            Spacer()
//                                            Image(systemName: "arrow.right")
//                                                .resizable()
//                                                .foregroundColor(Color("darkText"))
//                                                .frame(width: 25, height: 25)
//                                                .padding(.trailing)
//                                        }.padding(.horizontal)
//
//                                        Text("Login Yourself as Patient")
//                                            .padding(.horizontal)
//
//                                    }.padding()
//                                }
//
//                            }
//                        }
//
//
//                    }
//                    .presentationDetents([.fraction(0.40)])
//                }
//            }
//
//
//        }.alert(alertMessage, isPresented: $showingAlert) {
//            Button("OK", role: .cancel) {}
//        }
//        .onAppear {
//
//            //if already logged in skip to main screen
//            if Auth.auth().currentUser != nil {
//                print("Login Successfully")
//                path.append("redirectAuth")
//            }
//        }
//    }
//
//    func enableButtons() {
//        let emailIsGood = email.contains("@")
//        let passwordIsGood = password.count >= 6
//        buttonsDisabled = !(emailIsGood && passwordIsGood)
//    }
//}


struct User {
  var name: String
  var email: String
  var password: String
}

struct CreateUserView: View {
  @State private var name = ""
  @State private var email = ""
  @State private var password = ""
  @State private var error: String?
  
  var body: some View {
      VStack {
          TextField("Name", text: $name)
          TextField("Email", text: $email)
          SecureField("Password", text: $password)
          Button("Create Account") {
              //
          }
          
      }
  }
    
    
  
  func createAccount() {
    // Validate user data
    guard !name.isEmpty else {
      error = "Please enter your name"
      return
    }
    guard !email.isEmpty else {
      error = "Please enter your email"
      return
    }
    guard !password.isEmpty else {
      error = "Please enter your password"
      return
    }
    
    // Create user in Firebase
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      guard let user = authResult?.user, error == nil else {
        self.error = error?.localizedDescription ?? "Unknown error"
        return
      }
      
      // Save user data to Firestore
      let data: [String: Any] = [
        "name": name,
        "email": email
      ]
      Firestore.firestore().collection("users").document(user.uid).setData(data) { error in
        if let error = error {
          self.error = error.localizedDescription
        } else {
          // Clear form and show success message
          name = ""
          email = ""
          password = ""
          //error = "Account created successfully!"
        }
      }
    }
  }
}


struct testU_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
