//
//  chatLogView.swift
//  medicoz
//
//  Created by Sachin Sharma on 09/04/23.
//

import SwiftUI
import Firebase


struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let message = "message"
}

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
    let chatUser: ChatUser?
    @Published var chatMessages = [ChatMessage]()
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    private func fetchMessages() {
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
            self.message = ""
            print ("Successfully saved current user sending message")
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
            print ("SReceiver Received Message")
        }

    }
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
        .navigationTitle("\(chatUser?.name ?? "")")
        //.navigationTitle("Sachin Sharma")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.chatMessages) { text in
                    VStack{
                        if text.fromId == Firebase.Auth.auth().currentUser?.uid {
                            HStack {
                                Spacer()
                                HStack {
                                    Text(text.message)
                                }.padding()
                                    .background(Color("AccentColor"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } else {
                            HStack {
                                HStack {
                                    Text(text.message)
                                }.padding()
                                    .background(.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                }
                HStack{Spacer()}
                
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
                viewModel.handleSend()
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

struct chatLogView_Previews: PreviewProvider {
    static var previews: some View {
        chatLogView(chatUser: nil)
    }
}
