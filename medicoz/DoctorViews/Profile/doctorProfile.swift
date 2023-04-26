//
//  doctorProfile.swift
//  medicoz
//
//  Created by Sachin Sharma on 02/04/23.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct doctorProfile: View {
    @StateObject var sessionManager = SessionManager()
    @AppStorage ("uid") var userID: String = ""
    @AppStorage ("userRole") var userRole: String = ""
    @Environment (\.dismiss) private var dismiss
    @State var editMode: Bool = false
    @State var logoutAlert = false
    @ObservedObject private var viewModel = DataManager()
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    
                    VStack {
                        Text("Profile Details")
                            .font(.title)
                    }.padding(.horizontal).padding(.top, 10)
                    
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            //Name
                            VStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("lightAcc"))
                                    .frame(width: 360, height: 140)
                                    .overlay(
                                        HStack{
                                            
                                            WebImage(url: URL(string: viewModel.doctorData?.profileImage ?? ""))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipped()
                                                .cornerRadius(80)
                                                .overlay(RoundedRectangle(cornerRadius: 80)
                                                    .stroke(Color(.label), lineWidth: 1)
                                                )
                                                .shadow(radius: 5, x: 5, y: 5)
                                            
                                                
                                            
                                            VStack(alignment: .leading){
                                                Text("\(viewModel.doctorData?.name ?? "")")
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                                    .font(Font.custom("Poppins-Regular", size: 10))
                                                Text("@\(viewModel.doctorData?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? "")")
                                                //Text("@\(user.email.replacingOccurrences(of: "@gmail.com", with: ""))")
                                                    .font(.caption)
                                                    .foregroundColor(Color("lightText"))
                                            }.padding(.horizontal)
                                            Spacer()
                                        }.padding()
                                    )
                            }
                            
                            //Profle Sharing
                            VStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("darkAcc"))
                                    .frame(width: 360, height: 100)
                                    .overlay(
                                        HStack{
                                            VStack(alignment: .leading){
                                                Text("Share Your Profile")
                                                    .foregroundColor(.white)
                                                    .font(.title2)
                                            }.padding(.horizontal)
                                            Spacer()
                                            
                                            Button {
                                                //
                                            } label: {
                                                Capsule(style: .continuous)
                                                    .fill(Color("Accent"))
                                                    .frame(width: 160, height: 50)
                                                    .clipped()
                                                    .overlay {
                                                        HStack {
                                                            Text("Share Profile")
                                                                .foregroundColor(.white)
                                                        }
                                                        .padding(4)
                                                    }
                                            }
                                            
                                            
                                        }.padding()
                                    )
                            }.padding(.vertical)
                            
                            //Details
                            VStack{
                                HStack{
                                    Text("Details")
                                        .font(.title2)
                                    Spacer()
                                    Button {
                                        editMode.toggle()
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                        //.resizable()
                                            .font(.title3)
                                    }
                                    
                                }
                                
                                VStack{
                                    HStack{
                                        Text("Date of birth")
                                            .foregroundColor(Color("lightText"))
                                        Spacer()
                                        Text("\(viewModel.doctorData?.birthday ?? "")")
                                            .foregroundColor(Color("darkText"))
                                    }.padding(.vertical,5)
                                    HStack{
                                        Text("City")
                                            .foregroundColor(Color("lightText"))
                                        Spacer()
                                        Text("shimla")
                                            .foregroundColor(Color("darkText"))
                                    }.padding(.vertical,5)
                                    HStack{
                                        Text("Country")
                                            .foregroundColor(Color("lightText"))
                                        Spacer()
                                        Text("India")
                                            .foregroundColor(Color("darkText"))
                                    }.padding(.vertical,5)
                                    HStack{
                                        Text("Registration No")
                                            .foregroundColor(Color("lightText"))
                                        Spacer()
                                        Text("\(viewModel.doctorData?.regNo ?? "")")
                                            .foregroundColor(Color("darkText"))
                                    }.padding(.vertical,5)
                                    HStack{
                                        Text("Specialization")
                                            .foregroundColor(Color("lightText"))
                                        Spacer()
                                        Text("\(viewModel.doctorData?.spec ?? "")")
                                            .foregroundColor(Color("darkText"))
                                    }.padding(.vertical,5)
                                    
                                }.padding(.vertical)
                                
                            }.padding(.vertical)
                            
                            //Profile Share
                            VStack{
                                HStack{
                                    Text("Shared Profile")
                                        .font(.title2)
                                    Spacer()
                                    Button {
                                        //
                                    } label: {
                                        Image(systemName: "chevron.right")
                                    }
                                    
                                }
                                
                                HStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color("lightAcc"))
                                        .frame(width: 100, height: 55)
                                    
                                    VStack(alignment: .leading){
                                        Text("Dr. Anna Kowalsky")
                                        Text("7 Views")
                                            .foregroundColor(Color("Accent"))
                                    }
                                    Spacer()
                                }
                                
                            }
                            
                            //Sign Out:
                            VStack{
                                
                                Button {
                                    //TODO: Signout here
                                    logoutAlert = true
                                } label: {
                                    Text("Sign Out")
                                        .foregroundColor(.red)
                                        .frame(height: 35)
                                        .frame(maxWidth: .infinity)
                                }.buttonStyle(.bordered)
                                    .alert(isPresented: $logoutAlert) {
                                        Alert(
                                            title: Text("Logout"),
                                            message: Text("Are you sure to Logout"),
                                            primaryButton: .destructive(Text("OK"), action: {
                                                // Handle button 1 action
                                                do {
                                                    try Auth.auth().signOut()
                                                    sessionManager.userRole = nil
                                                    sessionManager.isLoggedIn = false
                                                    print("Signed Out Successfully!")
                                                    withAnimation {
                                                        userID = ""
                                                        userRole = ""
                                                    }
                                                    
                                                } catch {
                                                    print("Error signing out: \(error.localizedDescription)")
                                                }
                                            }),
                                            secondaryButton: .cancel(Text("Cancel"), action: {
                                                // Handle button 2 action
                                                
                                            })
                                        )
                                    }
                                    
                                
                                
                            }.padding(.top, 30)
                            
                        }.padding().frame(width: 360)
                    }.sheet(isPresented: $editMode, content: {
                        editProfile()
                    })
                }
            }
        }
    }
}

struct doctorProfile_Previews: PreviewProvider {
    static var previews: some View {
        doctorProfile()
    }
}
