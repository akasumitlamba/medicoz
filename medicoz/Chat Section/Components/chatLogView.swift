//
//  chatLogView.swift
//  medicoz
//
//  Created by Sachin Sharma on 09/04/23.
//

import SwiftUI

class ChatLogViewModel: ObservableObject {
    init() {
        
    }
    
    func handleSend(text: String) {
        
    }
}

struct chatLogView: View {
    
    let chatUser: userr?
    @State var message = ""
    
    @ObservedObject var viewModel = ChatLogViewModel()
    
    var body: some View {
        NavigationView {
            messagesView
                //.navigationTitle("\(chatUser?.name ?? "")")
                .navigationTitle("Sachin Sharma")
                .navigationBarTitleDisplayMode(.inline)
        }
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
                TextEditor(text: $message)
                    .opacity(message.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            Button {
                // handle message
                viewModel.handleSend(text: self.message)
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
