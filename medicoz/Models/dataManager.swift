//
//  dataManager.swift
//  medicoz
//
//  Created by Sachin Sharma on 01/02/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SDWebImageSwiftUI


struct UserData {
    let uid, email, role, name, birthday, gender, bloodGroup, weight, profileImage: String
}
struct PatientData {
    let uid, email, role, name, birthday, gender, bloodGroup, weight, profileImage: String
}
struct DoctorData {
    let uid, email, role, name, birthday, gender, regNo, spec, profileImage: String
}

class DataManager: ObservableObject {
    
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
            let name = data["name"] as? String ?? ""
            let birthday = data["birthday"] as? String ?? ""
            let gender = data["gender"] as? String ?? ""
            let bloodGroup = data["bloodGroup"] as? String ?? ""
            let weight = data["weight"] as? String ?? ""
            let profileImage = data["profileImage"] as? String ?? ""
            let regNo = data["regNo"] as? String ?? ""
            let spec = data["spec"] as? String ?? ""
            
            self.userData = UserData(uid: uid, email: email, role: role, name: name, birthday: birthday, gender: gender, bloodGroup: bloodGroup, weight: weight, profileImage: profileImage)
            
            self.patientData = PatientData(uid: uid, email: email, role: role, name: name, birthday: birthday, gender: gender, bloodGroup: bloodGroup, weight: weight, profileImage: profileImage)

            self.doctorData = DoctorData(uid: uid, email: email, role: role, name: name, birthday: birthday, gender: gender, regNo: regNo, spec: spec, profileImage: profileImage)
        }
    }
}
