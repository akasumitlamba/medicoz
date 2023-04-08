//
//  mainMessagesView.swift
//  medicoz
//
//  Created by Sachin Sharma on 03/04/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SDWebImageSwiftUI

struct ChatUser: Identifiable {
    var id = UUID().uuidString
    let email, name, profileImage: String
}

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    
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

            
            let email = data["email"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            
            let profileImage = data["profileImage"] as? String ?? ""
            
            self.chatUser = ChatUser(email: email, name: name, profileImage: profileImage)
        }
    }
}

struct userr: Identifiable {
    let id: String
    let uid: String
    let email: String
    let name: String
    let profileImage: String
}

struct mainMessagesView: View {
    @State private var searchText = ""
    @State private var users = [userr]()
    
    var filteredItems: [userr] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.email.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if !searchText.isEmpty {
                    List(filteredItems) { item in
                        HStack {
                            Image(item.profileImage)
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text(item.email.replacingOccurrences(of: "@gmail.com", with: ""))
                        }
                        
                    }
                } else {
                    ScrollView {
                        messagesView
                    }
                }
                
            }.navigationTitle("Chats")
                .searchable(text: $searchText)
        }.onAppear {
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
                users = documents.map { document in
                    let data = document.data()
                    let id = document.documentID
                    let uid = data["uid"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let profileImage = data["profileImage"] as? String ?? ""
                    return userr(id: id, uid: uid, email: email, name: name, profileImage: profileImage)
                }
            }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1)
                            )
                        
                        
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("AccentColor"))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
        }
    }
    
    @State var showNewMessageScreen = false
    
    private var newMessageButton: some View {
        Button {
            showNewMessageScreen.toggle()
        } label: {
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(20)
                    .padding(.horizontal)
                    .background(Color("darkAcc"))
                    .clipShape(Circle())
            }.padding(.bottom)
        }
        .fullScreenCover(isPresented: $showNewMessageScreen) {
            newMessageView()
        }
    }
}

struct mainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        mainMessagesView()
    }
}
