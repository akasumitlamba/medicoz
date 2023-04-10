//
//  chatLogView.swift
//  medicoz
//
//  Created by Sachin Sharma on 09/04/23.
//

import SwiftUI
import Firebase

class ChatLogViewModel: ObservableObject {
    
    @Published var message = ""
    @Published var errorMessage = ""
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
    }
    
    func handleSend() {
        print(message)
        guard let fromId = Firebase.Auth.auth().currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else { return }
        
        let senderDocument = Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ["fromId": fromId, "toId": toId, "message": self.message, "timestamp": Timestamp()] as [String : Any]
        
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
                ForEach(0..<10) { num in
                    HStack {
                        Spacer()
                        HStack {
                            Text("Dummy Message")
                        }.padding()
                            .background(Color("AccentColor"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
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
