//
//  doctorsList.swift
//  medicoz
//
//  Created by Sachin Sharma on 10/05/23.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct doctorsList: View {
    
    @State private var documents: [DocumentSnapshot] = [] // Store fetched documents
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    ScrollView {
                        ForEach(documents, id: \.documentID) { document in
                            VStack(spacing: 20) {
                                NavigationLink {
                                    //
                                } label: {
                                    VStack(spacing: 20) {
                                        //Image("myImage")
                                        WebImage(url: URL(string: document["profileImage"] as? String ?? ""))
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                                            .overlay {
                                                VStack {
                                                    Spacer()
                                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(.black.opacity(0.5))
                                                        .frame(height: 70, alignment: .bottom)
                                                        .clipped()
                                                        .overlay {
                                                            Group {
                                                                VStack{
                                                                    Spacer()
                                                                    HStack(spacing: 10) {
                                                                        VStack(alignment: .leading, spacing: 7) {
                                                                            HStack(spacing: 5) {
                                                                                Text("Dr.")
                                                                                    .font(.system(size: 14))
                                                                                    .foregroundColor(.white)
                                                                                //Text(document["doctor"] as? String ?? "")
                                                                                //Text("Hi")
                                                                                Text(document["name"] as? String ?? "")
                                                                                    .font(.system(size: 14))
                                                                                    .foregroundColor(.white)
                                                                            }
                                                                            //Text(document["disease"] as? String ?? "")
                                                                            //Text("Hello")
                                                                            Text(document["speaciality"] as? String ?? "")
                                                                                .font(.system(size: 20, weight: .bold))
                                                                                .foregroundColor(.white)
                                                                        }
                                                                        Spacer()

                                                                        //Text("location")
                                                                        Text(document["location"] as? String ?? "")
                                                                            .font(.system(size: 14, weight: .semibold))
                                                                            .foregroundColor(.white)

                                                                    }.padding()
                                                                }.padding(.vertical)
                                                            }
                                                        }
                                                    
                                                    
                                                }
                                            }
 
                                    }.padding(.bottom).cornerRadius(10)
                                }

                                
                            }.padding(.horizontal)
                        }.padding(.bottom, 50)
                    }
                }.background(Color(.init(white: 0.95, alpha: 1)))
                    .navigationBarTitle("Doctors List")
                .navigationBarTitleDisplayMode(.inline)
                

            }
        }
        .onAppear{
            fetchData()
        }
    }
    
    func fetchData() {
        
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        
        let query: Query = collectionRef.whereField("role", isEqualTo: "doctor")
            query.getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    
                    return
                }
                self.documents = documents
                
            }
    }
    
}

struct doctorProfileView: View {
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 20) {
                    VStack {
                        HStack{
                            Image("myImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 8) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Registration No :")
                                            .font(.subheadline)
                                        Text("1234")
                                            .font(.subheadline)
                                    }
                                    
                                    Text("Sachin Sharma")
                                        .font(.title)
                                        .bold()
                                    
                                }
                                
                                Text("Cardio in Kaloti")
                                    .font(.title3)
                            }
                            Spacer()
                        }.padding()
                    }
                    Divider()
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .frame(width: 180, height: 40)
                            .border(.gray).cornerRadius(5)
                            .cornerRadius(5)
                            .overlay {
                                
                                HStack {
                                    Image("icon1")
                                        .resizable()
                                        .accentColor(.green.opacity(0.5))
                                        .scaledToFit()
                                        .frame(width: 35, height: 35)
                                    Text("IN-CLINIC")
                                        .font(.subheadline)
                                    Text("VISITS")
                                        .font(.subheadline)
                                }
                            }
                        Spacer()
                    }.padding(.horizontal)
                    
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .overlay {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Image(systemName: "globe")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                        //Spacer()
                                    }.padding()
                                    
                                    VStack(alignment: .leading, spacing: 10){
                                        Text("English")
                                            .font(.title2)
                                            .bold()
                                        Text("Languages")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                            }
                    }.padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .overlay {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("ABOUT THE DOCTOR")
                                            .bold()
                                        Spacer()
                                    }.padding(.bottom, 10)
                                    Text("Hello")
                                }.padding()
                            }
                    }.padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .overlay {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("CLINIC")
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 40)
                                        Spacer()
                                    }.background(.green.opacity(0.5))
                                    Spacer()
                                }.cornerRadius(10)
                            }
                    }.padding(.horizontal)
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
        }
    }
}

struct doctorsList_Previews: PreviewProvider {
    static var previews: some View {
        //doctorsList()
        doctorProfileView()
    }
}
