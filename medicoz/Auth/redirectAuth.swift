//
//  redirectAuth.swift
//  medicoz
//
//  Created by Sachin Sharma on 14/02/23.
//

import SwiftUI
import Firebase

struct redirectAuth: View {
    
    @State var patientDocumentFound = false
    @State var doctorDocumentFound = false
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            
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
            else {
                VStack{
                    if patientDocumentFound {
                        patientHome()
                    } else if doctorDocumentFound {
                        DrHomeView()
                    } else {
                        accountSetup()
                    }
                }
            }
                
        }.onAppear {
            // Show loader when view appears
            isLoading = true
            
            patientApiCall()
            doctorApiCall()
                        
            // Simulate loading time
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLoading = false
            }
        }.edgesIgnoringSafeArea(.all).navigationBarBackButtonHidden(true).navigationBarHidden(true)
    }
    
    func patientApiCall() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("patients").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                patientDocumentFound = true
                //self.dataToDisplay = dataDescription
            } else {
                print("Document does not exist")
                patientDocumentFound = false
            }
       }
    }
    
    func doctorApiCall() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("doctors").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                doctorDocumentFound = true
                //self.dataToDisplay = dataDescription
            } else {
                print("Document does not exist")
                doctorDocumentFound = false
            }
       }
    }
    
}



struct redirectAuth_Previews: PreviewProvider {
    static var previews: some View {
        redirectAuth()
    }
}
