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

struct doctorsList_Previews: PreviewProvider {
    static var previews: some View {
        doctorsList()
    }
}
