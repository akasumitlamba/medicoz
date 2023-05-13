//
//  documentModel.swift
//  medicoz
//
//  Created by Sachin Sharma on 05/05/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class documentModel: Identifiable, ObservableObject {
    @Published var anyDocument = false
    @Published var isLoader = false
    
    @Published var documents: [DocumentSnapshot] = []
    
    init() {
        fetchData()
    }
 
    func fetchData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let db = Firestore.firestore()
        db.collection("medicalDocuments")
            .document(uid)
            .collection("documents")
            .order(by: "timestamp", descending: true) // Order by the "time" field in descending order
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    self.anyDocument = false
                    return
                }
                self.anyDocument = true
                self.documents = documents
            }
    }
}
