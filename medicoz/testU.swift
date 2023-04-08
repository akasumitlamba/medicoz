//
//  testU.swift
//  medicoz
//
//  Created by Sachin Sharma on 05/04/23.
//

import SwiftUI
import Firebase
import FirebaseAuth



struct Item: Identifiable {
    let id: String
    let email: String
}

struct testU: View {
    @State private var searchText = ""
    @State private var items = [Item]()

    var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.email.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack{
                
            }
            .searchable(text: $searchText)
            .navigationTitle("Search")
        }
        .onAppear {
            fetchFirebaseData()
        }
    }

    func fetchFirebaseData() {
        let db = Firestore.firestore()
        db.collection("users")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                items = documents.map { document in
                    let data = document.data()
                    let id = document.documentID
                    let email = data["email"] as? String ?? ""
                    return Item(id: id, email: email)
                }
            }
    }
}



struct testU_Previews: PreviewProvider {
    static var previews: some View {
        testU()
    }
}
