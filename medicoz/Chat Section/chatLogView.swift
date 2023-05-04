//
//  chatLogView.swift
//  medicoz
//
//  Created by Sachin Sharma on 09/04/23.
//

import SwiftUI
import Firebase




struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, message: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.message = data[FirebaseConstants.message] as? String ?? ""
    }
}

class ChatLogViewModel: ObservableObject {
    
    @Published var message = ""
    @Published var errorMessage = ""
    var chatUser: ChatUser?
    @Published var chatMessages = [ChatMessage]()
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let fromId = Firebase.Auth.auth().currentUser?.uid else { return }
        guard let toId = chatUser?.id else { return }
        Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    func handleSend() {
        print(message)
        guard let fromId = Firebase.Auth.auth().currentUser?.uid else {return}
        
        guard let toId = chatUser?.id else { return }
        
        let senderDocument = Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.message: self.message, "timestamp": Timestamp()] as [String : Any]
        
        senderDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into firestore: \(error)"
                print("Failed to save message into firestore: \(error)")
                return
            }
            
            print ("Successfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.message = ""
            self.count += 1
        }
        
        let receiverDocument = Firestore.firestore()
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        receiverDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into firestore: \(error)"
                print("Failed to save message into firestore: \(error)")
                return
            }
            print ("Receiver Received Message")
        }

    }
    
    private func persistRecentMessage() {
        
        guard let chatUser = chatUser else { return }
        
        guard let uid = Firebase.Auth.auth().currentUser?.uid else {return}
        guard let toId = self.chatUser?.id else { return }
        
        let document = Firestore.firestore()
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.message: self.message,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImage: chatUser.profileImage,
            FirebaseConstants.email: chatUser.email,
            FirebaseConstants.name: chatUser.name
            
        ] as [String : Any]
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                return
            }
        }
        
    }
    
    @Published var count = 0
}

struct chatLogView: View {
    
    let chatUser: ChatUser?

    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.viewModel = .init(chatUser: chatUser)
    }
    
    @ObservedObject var viewModel: ChatLogViewModel
    
    var body: some View {
        ZStack{
            messagesView
        }
        .navigationTitle("\(viewModel.chatUser?.name ?? "")")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ScrollViewReader { ScrollViewProxy in
                    VStack {
                        ForEach(viewModel.chatMessages) { message in
                            MessageView(message: message)
                            
                        }
                        HStack{Spacer()}
                            .id(self.emptyScrollToString)
                    }
                    .onReceive(viewModel.$count) { _ in
                        withAnimation(.easeIn(duration: 0.5)) {
                            ScrollViewProxy.scrollTo(self.emptyScrollToString, anchor: .bottom)
                        }
                    }
                }
                
            }.background(Color(.init(white: 0.95, alpha: 1)))
                .safeAreaInset(edge: .bottom) {
                    chatBottom
                        .background(Color(.systemBackground))
            }
        }
    }
    
    private var chatBottom: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 24))
                .foregroundColor(Color.gray)
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $viewModel.message)
                    .opacity(viewModel.message.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            Button {
                // handle message
                if !viewModel.message.isEmpty {
                    viewModel.handleSend()
                }
            } label: {
                Text("Send")
            }.buttonStyle(.borderedProminent)

        }.padding(.horizontal)
            .padding(.vertical, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

struct MessageView: View {
    
    let message: ChatMessage
    var body: some View {
        VStack{
            if message.fromId == Firebase.Auth.auth().currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.message)
                    }.padding()
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.message)
                    }.padding()
                        .background(Color("lightAcc"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct chatLogView_Previews: PreviewProvider {
    static var previews: some View {
        //chatLogView(chatUser: nil)
        SplashScreenView()
    }
}
