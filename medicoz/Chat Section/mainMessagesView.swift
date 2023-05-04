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
import FirebaseFirestoreSwift



struct findUser: Identifiable {
    var id = UUID().uuidString
    let email, name, profileImage: String
}

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: findUser?
    
    
    init() {
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    @Published var recentMessages = [RecentMessage]()
    private var firestoreListener: ListenerRegistration?
    
    private func fetchRecentMessages() {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        
        Firebase.Firestore.firestore()
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: RecentMessage?.self) {
                            self.recentMessages.insert (rm, at: 0)
                        }
                    } catch {
                        print (error)
                    }
                })
            }
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
            
            self.chatUser = findUser(email: email, name: name, profileImage: profileImage)
        }
    }
}

struct mainMessagesView: View {
    @State private var searchText = ""
    @State private var users = [ChatUser]()
    let didSelectNewUser: (ChatUser) -> ()
    @State var chatUser: ChatUser?
    @State var shouldNavigateToChatLogView = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = MainMessagesViewModel()
    
    var chatLogViewModel = ChatLogViewModel(chatUser: nil)
    
    //filter users from firebase
    var filteredItems: [ChatUser] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.email.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    if !searchText.isEmpty {
                        List(filteredItems) { user in
                            
                            NavigationLink  {
                                chatLogView(chatUser: user)
                            } label: {
                                HStack {
                                    WebImage(url: URL(string: user.profileImage))
                                        .resizable()
                                        .scaledToFill()
                                        .clipped()
                                        .frame(width: 45, height: 45)
                                        .cornerRadius(45)
                                        .overlay(RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color(.label), lineWidth: 1)
                                        )
                                    
                                    VStack(alignment: .leading){
                                        Text(user.name)
                                        Text("@\(user.email.replacingOccurrences(of: "@gmail.com", with: ""))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }.padding(.horizontal, 10)
                                }
                            }
                        }
                        .onChange(of: searchText) { _ in
                            // This will dismiss the search bar when the search text changes
                            // (i.e. when a search result is selected)
                            //UIApplication.shared.dismissSearch()
                            UIApplication.shared.dismissSearch()
                        }
                    } else {
                        ScrollView {
                            messagesView
                        }
                    }
                    
                    NavigationLink("", destination: chatLogView(chatUser: chatUser), isActive: $shouldNavigateToChatLogView)
                    
                    

                    
                }.navigationTitle("Chats")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarRole(.browser)
                    .searchable(text: $searchText)
                
            }.background(Color(.init(white: 0.95, alpha: 1)))
                .onAppear {
                    fetchFirebaseData()
                    presentationMode.wrappedValue.dismiss()
                    searchText = ""
                    dismissKeyboard()
            }
        }
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                    return ChatUser(id: id, uid: uid, email: email, name: name, profileImage: profileImage)
                }
            }
    }
    
    private var messagesView: some View {
       
        ScrollView {
            ForEach(viewModel.recentMessages) { recentMessages in
                VStack {
                    Spacer()
                    Button {
                        let uid = Firebase.Auth.auth().currentUser?.uid == recentMessages.fromId ? recentMessages.toId : recentMessages.fromId
                        
                        self.chatUser = .init(id: uid, uid: uid, email: recentMessages.email, name: recentMessages.name, profileImage: recentMessages.profileImage)
                        
                        self.chatLogViewModel.chatUser = self.chatUser
                        self.chatLogViewModel.fetchMessages()
                        self.shouldNavigateToChatLogView.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 90)
                            .overlay {
                                HStack(spacing: 10) {
                                    WebImage(url: URL(string: recentMessages.profileImage))
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 55, height: 55)
                                        .padding(8)

                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(recentMessages.name)
                                            .font(.system(size: 20, weight: .bold))
                                        Text(recentMessages.message)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.lightGray))
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()

                                    Text(recentMessages.timeAgo)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color("AccentColor"))
                                }
                                .padding(.horizontal)
                            }
                        }

                    }.padding(.horizontal)
                }.padding(.bottom, 50)
            }




        

    }
}

struct profileViewToOther: View {
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Spacer()
                VStack(alignment: .center, spacing: 20) {
                    Image("myImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180, alignment: .top)
                        .clipShape(Circle())
                        .shadow(color: .pink, radius: 5, x: 5, y: 5)
                    Text("Your Name")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(.largeTitle))
                        .shadow(radius: 5)
                    Text("IOS | FrontEnd Developer")
                        .foregroundColor(.white)
                        .font(.body)
                    HStack(spacing: 40) {
                        Image(systemName: "heart.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Image(systemName: "network")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Image(systemName: "message.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Image(systemName: "phone.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                    }
                    .foregroundColor(.white)
                    .shadow(color: .pink, radius: 5, y: 5)
                    .frame(width: 250, height: 50, alignment: .center )
                }
                Spacer()
                
                VStack(alignment: .center, spacing: 30) {
                    RoundedRectangle(cornerRadius: 120)
                        .frame(width: 200, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .shadow(color: .pink, radius: 8, y: 8)
                        .overlay(
                            Text("Follow")
                                .fontWeight(.bold)
                                .foregroundColor(.pink)
                                .font(.system(size: 30))
                        )
                    
                    HStack(alignment: .center, spacing: 40) {
                        VStack {
                            Text("1775")
                                .font(.title)
                                .foregroundColor(.pink)
                            Text("Appreciations")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        VStack {
                            Text("800")
                                .font(.title)
                                .foregroundColor(.pink)
                            Text("Followers")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        VStack {
                            Text("231")
                                .font(.title)
                                .foregroundColor(.pink)
                            Text("Following")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                    }
                    Text("About You")
                        .font(.system(size: 30))
                        .font(.system(.caption))
                    Text("I'm a iOS Frontend Developer. Welcome to the series of iOS-15 projects. Let's dive deeper and create some more exciting projects.")
                        .font(.system(.body))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .opacity(0.9)
                    
                }
            }.padding()
        }
    }
}


struct doctorP: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color.white)
                    .frame(height: 730, alignment: .bottom)
                    .clipped()
                    .overlay {
                        VStack {
                            
                            Group {
                                Text("Dr. Sachin Sharma")
                                    .font(.title).padding(7)
                                    .padding(.top, 60)
                                    .bold()
                                Text("Heart Speacialist")
                            }
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("lightAcc"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .overlay {
                                    HStack(spacing: 30) {
                                        VStack {
                                            Text("Patients")
                                                .font(.title3)
                                                .foregroundColor(.black.opacity(0.5))
                                            Text("1000")
                                                .foregroundColor(Color("darkAcc"))
                                                .font(.title)
                                                .bold()
                                        }
                                        Text("|")
                                            .font(.largeTitle)
                                            .foregroundColor(.black.opacity(0.5))
                                        VStack {
                                            Text("Experience")
                                                .font(.title3)
                                                .foregroundColor(.black.opacity(0.5))
                                            Text("10yr")
                                                .foregroundColor(Color("darkAcc"))
                                                .font(.title)
                                                .bold()
                                        }
                                        Text("|")
                                            .font(.largeTitle)
                                            .foregroundColor(.black.opacity(0.5))
                                        VStack {
                                            Text("Rating")
                                                .font(.title3)
                                                .foregroundColor(.black.opacity(0.5))
                                            Text("4.8")
                                                .foregroundColor(Color("darkAcc"))
                                                .font(.title)
                                                .bold()
                                        }
                                    }
                                }
                                .padding(.top)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("About Doctor")
                                        .font(.title2)
                                    Spacer()
                                }
                                Button {
                                    //
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                                            .foregroundColor(.black)
                                    }
                                        
                                }

                            }.padding(.top)
                            Spacer()
                            
                        }.padding()
                    }
                  
                
                    
            }.edgesIgnoringSafeArea(.all)
            VStack {
                Circle()
                    .frame(width: 130, height: 130)
                    .offset(x: 0, y: 80)
                Spacer()
            }
                
            
        }.background(Color("darkAcc"))
    }
}


struct mainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        //        mainMessagesView(didSelectNewUser: { item
        //            in
        //            print(item.email)
        //        })
        //SplashScreenView(isActive: true)
        doctorP()
        //chatLogView(chatUser: self.chatUser)
    }
}

extension UIApplication {
    func dismissSearch() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
