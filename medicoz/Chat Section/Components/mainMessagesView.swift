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



struct mainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    
    @ObservedObject private var viewModel = MessageViewModel()
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            WebImage(url: URL(string: viewModel.patientData?.profileImage ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)

            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.patientData?.name ?? "")")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    //.foregroundColor(Color(.label))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color("AccentColor"))
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                }),
                    .cancel()
            ])
        }
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                customNavBar
                ScrollView {
                    messagesView
                }
            }
            .overlay(
                newMessageButton, alignment: .bottomTrailing)
            .navigationBarHidden(true)
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
    
    private var newMessageButton: some View {
        Button {
            
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
    }
}

struct mainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        mainMessagesView()
    }
}
