//
//  SessionManager.swift
//  medicoz
//
//  Created by Sachin Sharma on 01/04/23.
//

import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import Darwin
import Foundation

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
    
    @Published private var image: UIImage? = nil
    @Published var showAlert = false
    @Published var alertMessages = ""
    @Published private var name = ""
    @Published var birthday: Date = Date()
    @Published var gender = ""
    @Published var weight: String = ""
    @Published var bg: String = "choose"
    var window: UIWindow?
    
    @Published var doc = false
    @Published var pat = false
    @Published var navTitleSheet = false
    @Published var showView = true
    @AppStorage ("uid") var userID: String = ""
    @AppStorage ("userRole") var role: String = ""
    @Published var patientDocumentNotFound = false
    @Published var doctorDocumentNotFound = false
    
    
    func registerUser(email: String, password: String, role: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {//login error occured
                completion(.failure(error))
                print("SignUp Error: \(error.localizedDescription)")
                self.alertMessage = "SignUp Error: \(error.localizedDescription)"
                self.showingAlert = true
            }
            
            else if let user = result?.user {
                let randomNumber = abs(UUID().hashValue) % 1000000000
                let numericId = String(format: "%010d", randomNumber)

                let userData = [
                    "email": user.email ?? "",
                    "role": role,
                    "uid": numericId
                ]
                
                
                    self.userID = user.uid
                    if role == "patient" {
                        self.patientApiCall()
                        
                    } else {
                        self.doctorApiCall()
                    }
                
                
                Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                    if let error = error {
                        print("Error adding user data to Firestore: \(error.localizedDescription)")
                        self.alertMessage = "SignUp Error: \(error.localizedDescription)"
                        self.showingAlert = true
                        completion(.failure(error))
                    } else {
                        //self.user = User
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.isLoading = false
                        }
                        print("User data added to Firestore")
                        print("Successfully Registered: \(result?.user.uid ?? "")")
                        //TODO: load next screen
                        self.isLoggedIn = true
                        if role == "patient" {
                            self.patientApiCall()
                        } else {
                            self.doctorApiCall()
                        }
                        self.isLoading = false
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
            }
            if let result = result {
                //TODO: load next screen
                self.isLoggedIn = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.isLoading = false
                }
                withAnimation {
                    self.userID = result.user.uid
                }
                print("Successfully LoggedIn: \(result.user.uid)")
            }
        }
    }
    
    func currUserLoginWithRole() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
            fetchUserRole { result in
                switch result {
                case .success(let role):
                    // Handle the role that was fetched
                    print("Fetched role: \(role)")
                case .failure(let error):
                    // Handle the error that occurred
                    print("Error fetching role: \(error.localizedDescription)")
                }
            }
        } else {
            showView = true
            if showView {
                pat = true
            } else {
                doc = true
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            userRole = nil
            self.isLoggedIn = false
            print("Signed Out Successfully!")
            
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.isLoading = false
                }
                //self.dataToDisplay = dataDescription
            } else {
                print("Document does not exist")
                self.patientDocumentFound = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.isLoading = false
                }
            }
       }
    }
    
    func doctorApiCall() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("doctors").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.doctorDocumentFound = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.isLoading = false
                }
                //self.dataToDisplay = dataDescription
            } else {
                print("Document does not exist")
                self.doctorDocumentFound = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.isLoading = false
                }
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


