//
//  SessionManager.swift
//  medicoz
//
//  Created by Sachin Sharma on 01/04/23.
//

import Firebase
import FirebaseAuth
import SwiftUI

enum UserRole: String {
    case role1 = "patient"
    case role2 = "doctor"
}

class SessionManager: ObservableObject {
    
    @Published var isLoggedIn = false
    var userRole: UserRole?
    
    @Published private var showingAlert = false
    @Published private var alertMessage = ""
    
    @Published var patientDocumentFound = false
    @Published var doctorDocumentFound = false
    @Published var isLoading = false
    @Published var path = NavigationPath()
    //@AppStorage("UserRole") var UserRole: String = ""
    
    
    func registerUser(email: String, password: String, role: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {//login error occured
                completion(.failure(error))
                print("SignUp Error: \(error.localizedDescription)")
                self.alertMessage = "SignUp Error: \(error.localizedDescription)"
                self.showingAlert = true
            } else if let user = result?.user {
                let userData = [
                    "email": user.email ?? "",
                    "role": role
                ]
                Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                    if let error = error {
                        print("Error adding user data to Firestore: \(error.localizedDescription)")
                        self.alertMessage = "SignUp Error: \(error.localizedDescription)"
                        self.showingAlert = true
                        completion(.failure(error))
                    } else {
                        //self.user = User(uid: user.uid, email: user.email ?? "", role: role)
                        self.isLoggedIn = true
                        //completion(.success(self.user!))
                        print("User data added to Firestore")
                        print("Successfully Registered: \(result?.user.uid ?? "")")
                        //TODO: load next screen
                        self.path.append("redirectAuth")
                    }
                }
            }
        }
    }
    
    func authenticateUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            if let error = error {//login error occured
                print("SignIn Error: \(error.localizedDescription)")
                self.alertMessage = "SignIn Error: \(error.localizedDescription)"
                self.showingAlert = true
            } else {
                print("Successfully LoggedIn: \(result?.user.uid ?? "")")
                //TODO: load next screen
                self.path.append("redirectAuth")
                self.isLoggedIn = true
                self.fetchUserRole(completion: completion)
            }
        }
    }
    
    func loading() {
        if isLoading {
            // Full screen loader here
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
        }
    }
    func logout() {
        do {
            try Firebase.Auth.auth().signOut()
            isLoggedIn = false
            userRole = nil
            
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func patientApiCall() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("patients").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.patientDocumentFound = true
                //self.dataToDisplay = dataDescription
            } else {
                print("Document does not exist")
                self.patientDocumentFound = false
            }
       }
    }
    
    func doctorApiCall() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("doctors").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.doctorDocumentFound = true
                //self.dataToDisplay = dataDescription
            } else {
                print("Document does not exist")
                self.doctorDocumentFound = false
            }
       }
    }
    
    func fetchUserRole(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Firebase.Auth.auth().currentUser else { return }
        let userDocRef = Firestore.firestore().collection("users").document(currentUser.uid)
        userDocRef.getDocument { [weak self] document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = document,
                  document.exists,
                  let data = document.data(),
                  let roleString = data["role"] as? String,
                  let role = UserRole(rawValue: roleString) else {
                completion(.failure(NSError(domain: "SessionManager", code: -1, userInfo: ["message": "Invalid user document"])))
                return
            }
            self?.userRole = role
            self?.isLoggedIn = true
            // Store user role in AppStorage
            completion(.success(()))
        }
    }
}


