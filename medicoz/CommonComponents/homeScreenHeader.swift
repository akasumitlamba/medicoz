//
//  homeScreenHeader.swift
//  medicoz
//
//  Created by Sachin Sharma on 21/04/23.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct homeScreenHeader: View {
    @Environment (\.dismiss) private var dismiss
    @ObservedObject private var viewModel = DataManager()
    @State var logoutAlert = false
    @State var alertMessage = ""
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: profileView()) {
                    WebImage(url: URL(string: viewModel.userData?.profileImage ?? ""))
                    //Image("myImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .clipShape(Circle())
                        .cornerRadius(60)
                        //.shadow(radius: 5, x: 5, y: 5)
                }.padding(.trailing, 10)

                //Text("Sachin Sharma")
                Text("\(viewModel.userData?.name ?? "")")
                    .font(.title2).bold()
                Spacer()
                
                NavigationLink(destination: mainMessagesView(didSelectNewUser: { item in
                    print(item.email)
                })) {
                    HStack {
                        Image("message")
                        //Text("Message") // Use the Text view to display the string value of the image name
                    }
                }

             
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

struct homeScreenHeader_Previews: PreviewProvider {
    static var previews: some View {
        homeScreenHeader()
    }
}
