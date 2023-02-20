//
//  newProfileView.swift
//  medicoz
//
//  Created by Sachin Sharma on 17/02/23.
//

import SwiftUI

struct profileView: View {
    
    @State var editMode: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    VStack {
                        Text("Profile Details")
                            .padding()
                            .font(.title2)
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            //Name
                            VStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("lightAcc"))
                                    .frame(width: 360, height: 140)
                                    .overlay(
                                        HStack{
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 80, height: 80)
                                                .shadow(radius: 5, x: 5, y: 5)
                                            
                                            VStack(alignment: .leading){
                                                Text("Sachin Sharma")
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                                    .font(Font.custom("Poppins-Regular", size: 10))
                                                Text("Male")
                                                    .font(.title3)
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
                                        Text("July 28, 2001")
                                            .foregroundColor(Color("darkText"))
                                    }.padding(.vertical,5)
                                    HStack{
                                        Text("City")
                                            .foregroundColor(Color("lightText"))
                                        Spacer()
                                        Text("Shimla")
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
                                        Text("Blood Group")
                                            .foregroundColor(Color("lightText"))
                                        Spacer()
                                        Text("B+")
                                            .foregroundColor(Color("darkText"))
                                    }.padding(.vertical,5)
                                    HStack{
                                        Text("Weight")
                                            .foregroundColor(Color("lightText"))
                                        Spacer()
                                        Text("65")
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
                        }.padding().frame(width: 360)
                    }.sheet(isPresented: $editMode, content: {
                        editProfile()
                    })
                }
            }
        }
    }
}

struct profileView_Previews: PreviewProvider {
    static var previews: some View {
        profileView()
    }
}
