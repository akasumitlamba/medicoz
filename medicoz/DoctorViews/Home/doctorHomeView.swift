//
//  doctorHomeView.swift
//  medicoz
//
//  Created by Sachin Sharma on 02/04/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI
import FirebaseStorage

struct doctorHomeView: View {
    
    @State var showDocuments = false
    //@Binding var selectedTab: Int
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    homeScreenHeader()

                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.gray)
                        .frame(height: 1)

                    // Divider()
                    
                    //Scroller Start
                    ScrollView(showsIndicators: false) {
                        //patientDocumentSearch()
                        
                        ZStack {
                            VStack {
                                //Locker Banner Start
                                ZStack {
                                    VStack {
                                        HStack(alignment: .center, spacing: 20) {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color("darkAcc"))
                                                .frame(height: 170)
                                                .overlay(
                                                    HStack {
                                                        VStack(alignment: .leading){
                                                            Text("Patients Health Locker")
                                                                .multilineTextAlignment(.leading)
                                                                .foregroundColor(.white)
                                                                .font(.title2)
                                                            Spacer()
                                                            Text("Quickle view patients health records")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                            Spacer()

                                                            NavigationLink(destination: dView(didSelectNewUser: { item in
                                                                print(item.email)
                                                            })) {
                                                                Text("Click Here")
                                                                    .padding(.horizontal)
                                                                    .padding(.vertical, 10)
                                                                    .background(.white)
                                                                    .cornerRadius(10)
                                                            }
                                                        


                                                        }.padding(.leading).padding(.vertical)
                                                        Spacer()
                                                        Image("pp")
                                                            .resizable()
                                                            //.frame(width: 150, height: 140)
                                                            .scaledToFit()
                                                            .padding(.vertical)
                                                            .padding(.trailing)
                                                    }
                                                )
                                        }.padding()
                                    }
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarHidden(true)
                                }
                                
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    //Scroller End
                }
            }.edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .toolbar {
                    Button("Sign Out") {
                        //TODO: Signout here
                        do {
                            try Auth.auth().signOut()
                            print("Signed Out Successfully!")
                            dismiss()
                        } catch {
                                print("ERROR: Could not sign out!")
                        }
                    }
            }
        }
    }
}

struct patientDocumentSearch: View {
    @State private var searchText = ""
    @State private var users = [ChatUser]()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = MainMessagesViewModel()
    
    var filteredItems: [ChatUser] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.email.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
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
//                .onChange(of: searchText) { _ in
//                    // This will dismiss the search bar when the search text changes
//                    // (i.e. when a search result is selected)
//                    //UIApplication.shared.dismissSearch()
//                    UIApplication.shared.dismissSearch()
//                }
            }
            //.navigationTitle("Documents")
               // .navigationBarTitleDisplayMode(.inline)
                .toolbarRole(.browser)
                .searchable(text: $searchText)
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
                    return ChatUser(id: id, uid: uid, email: email, name: name, profileImage: profileImage)
                }
            }
    }
    
}

struct doctorHeader: View {
    @Environment (\.dismiss) private var dismiss
    @State var logoutAlert = false
    @State var alertMessage = ""
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 80, height: 80)
                    .clipped()
                VStack(alignment: .leading) {
                    Text("Welcome!")
                        .frame(alignment: .leading)
                        .clipped()
                        .font(.title2)
                        .foregroundColor(Color("lightText"))
                    Text("Sachin Sharma")
                        .font(.title)
                        .foregroundColor(Color("darkText"))
                    
                }
                .padding()
                .frame(alignment: .leading)
                .clipped()
                Spacer()
            }
            .padding()
            .padding(.top, 50)
        }.alert(isPresented: $logoutAlert) {
            getAlert()
        }
    }
    
    private func getAlert() -> Alert {
        return Alert(
            title: Text("Log Out"),
            message: Text("Are you sure?"),
            primaryButton: .destructive(Text("Log Out"), action: {
                //TODO: Signout here
                do {
                    try Auth.auth().signOut()
                    print("Signed Out Successfully!")
                    dismiss()
                } catch {
                        print("ERROR: Could not sign out!")
                }
            }),
            secondaryButton: .cancel()
        )
    }

}

struct dView: View {
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
                                //chatLogView(chatUser: user)
                                patientDoc(chatUser: user)
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
                    } else {
                        Text("Search Patient With Username")
                    }
                    
                    
                    
                    NavigationLink("", destination: chatLogView(chatUser: chatUser), isActive: $shouldNavigateToChatLogView)
                    //NavigationLink("", destination: patientDoc(chatUser: user), isActive: $shouldNavigateToChatLogView)
                    
                    

                    
                }.navigationTitle("Patients")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarRole(.browser)
                    .searchable(text: $searchText)
                    .background(Color(.init(white: 0.95, alpha: 1)))
                
            }.background(Color(.init(white: 0.95, alpha: 1)))
                .onAppear {
                    fetchFirebaseData()
                    presentationMode.wrappedValue.dismiss()
                    searchText = ""
                    dismissKeyboard()
            }
        }.background(Color(.init(white: 0.95, alpha: 1)))
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

struct patientDoc: View {
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    @State private var showPreview = false
    @State private var disease = ""
    @State private var doctor = ""
    @State private var clinic = ""
    @State private var location = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var showToast = false
    @State private var isLoading = false
    @State private var isButtonPressed = false
    @State private var anyDocument = false
    @State private var isLoader = false
    @State var userid = ""
    @State var text = ""
    
    let chatUser: ChatUser?

    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.viewModel = .init(chatUser: chatUser)
    }
    
    @ObservedObject var viewModel: ChatLogViewModel
    
    @State private var documents: [DocumentSnapshot] = [] // Store fetched documents
    
    
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            if anyDocument {
                VStack {
                    ScrollView {
                        ForEach(documents, id: \.documentID) { document in
                            NavigationLink {
                                //
                            } label: {
                                VStack {
                                    Spacer()
                                    VStack {
                                        WebImage(url: URL(string: document["documentUrl"] as? String ?? ""))
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                                            .overlay {
                                                Group {
                                                    VStack {
                                                        Spacer()
                                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                            .fill(.black.opacity(0.5))
                                                            .frame(height: 70, alignment: .bottom)
                                                            .clipped()
                                                            .overlay {
                                                                Group {
                                                                    HStack(spacing: 10) {
                                                                        VStack(alignment: .leading, spacing: 10) {
                                                                            Text(document["disease"] as? String ?? "")
                                                                                .font(.system(size: 20, weight: .bold))
                                                                                .foregroundColor(.white)
                                                                            HStack(spacing: 5) {
                                                                                Text("Dr.")
                                                                                    .font(.system(size: 14))
                                                                                    .foregroundColor(.white)
                                                                                Text(document["doctor"] as? String ?? "")
                                                                                    .font(.system(size: 14))
                                                                                    .foregroundColor(.white)
                                                                            }
                                                                        }
                                                                        Spacer()
                                                                        if let timestamp = document["timestamp"] as? Timestamp {
                                                                            Text(timeAgo(timestamp: timestamp))
                                                                                .font(.system(size: 14, weight: .semibold))
                                                                                .foregroundColor(.white)
                                                                        }
                                                                        
                                                                       
                                                                    }.padding()
                                                                }
                                                            }
                                                    }
                                                }
                                            }
                                    }
                                }.padding(.horizontal)
                            }
                            
                        }.padding(.bottom, 50)
                    }
                    .background(Color(.init(white: 0.95, alpha: 1)))
                    .navigationTitle("\(viewModel.chatUser?.name ?? "")")
                    .navigationBarTitleDisplayMode(.inline)
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
            }
            else {
                Text("No Documents Found")
                    .font(.title)
                    .foregroundColor(.black.opacity(0.5))
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    func dateString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
    
    func timeAgo(timestamp: Timestamp) -> String {
           let formatter = RelativeDateTimeFormatter()
           formatter.unitsStyle = .abbreviated
           return formatter.localizedString(for: timestamp.dateValue(), relativeTo: Date())
       }
    
    func fetchData() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        userid = "\(viewModel.chatUser?.uid ?? "")"
        
        let db = Firestore.firestore()
        db.collection("medicalDocuments")
            .document(userid)
            .collection("documents")
            .order(by: "timestamp", descending: true) // Order by the "time" field in descending order
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    anyDocument = false
                    return
                }
                self.documents = documents
                anyDocument = true
            }
    }
    
    
    
}



struct doctorHomeView_Previews: PreviewProvider {
    static var previews: some View {
        patientDocumentSearch()
    }
}
