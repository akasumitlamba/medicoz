//
//  MessageViewModel.swift
//  medicoz
//
//  Created by Sachin Sharma on 04/04/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


struct UserData {
    let uid, email, role: String
}

struct PatientData {
    let name, profileImage: String
}

struct DoctorData {
    let name, profileImage: String
}

class MessageViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var userData: UserData?
    @Published var patientData: PatientData?
    @Published var doctorData: DoctorData?
    
    
    init() {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                
            }

            let uid = data["uid"] as? String ?? ""
            let role = data["role"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            
            self.userData = UserData(uid: uid, email: email, role: role)
        }
    }
    
    private func fetchPatient() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        
        Firestore.firestore().collection("patients").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
//            self.errorMessage = "123"
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                
            }
//            self.errorMessage = "Data: \(data.description)"
            let name = data["name"] as? String ?? ""
            let profileImage = data["profileImage"] as? String ?? ""
            
            self.patientData = PatientData(name: name, profileImage: profileImage)
            
//            self.errorMessage = chatUser.profileImageUrl
            
        }
    }
    
    private func fetchDoctor() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        
        Firestore.firestore().collection("patients").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
//            self.errorMessage = "123"
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                
            }
//            self.errorMessage = "Data: \(data.description)"
            let name = data["name"] as? String ?? ""
            let profileImage = data["profileImage"] as? String ?? ""
            
            self.doctorData = DoctorData(name: name, profileImage: profileImage)
            
//            self.errorMessage = chatUser.profileImageUrl
            
        }
    }
    
    
}
