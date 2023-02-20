//
//  dataManager.swift
//  medicoz
//
//  Created by Sachin Sharma on 01/02/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class DataManager: ObservableObject {
    @Published var patients: [Patient] = []
    
    init() {
        fetchPatient()
    }
    
    func fetchPatient() {
        patients.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("patients")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let age = data["age"] as? String ?? ""
                    let gender = data["gender"] as? String ?? ""
                    let mobile_no = data["mobile_no"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let weight = data["weight"] as? String ?? ""
                    
                    let patient = Patient(id: id, age: age, gender: gender, Mobile_No: mobile_no, name: name, weight: weight)
                    self.patients.append(patient)
                }
            }
        }
    }
    
    
//    func addPatient(patientData: String) {
//        let db = Firestore.firestore()
//        let ref = db.collection ("patients").document(patientData)
//        ref.setData(["firstname": firstname, "middlename": middlename, "id": 10, "age": age]) { error in
//            if let error = error{
//                print(error.localizedDescription)
//            }
//        }
//    }
    
}
