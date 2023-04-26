//
//  medicalHistory.swift
//  medicoz
//
//  Created by Sachin Sharma on 24/01/23.
//

import SwiftUI

struct medicalHistory: View {
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    @State private var showPreview = false
    @State private var disease = ""
    @State private var doctor = ""
    @State private var clinic = ""
    @State private var location = ""
    
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(0..<10, id: \.self) { num in
                            VStack {
                                Spacer()
                                NavigationLink {
                                    //chatLogView(chatUser: self.chatUser)
                                } label: {
                                    
                                    
                                    
                                    VStack {
                                        Image("myImage")
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                                            .overlay {
                                                Group {
                                                    VStack {
                                                        Spacer()
                                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                            .fill(.black.opacity(0.5))
                                                            .frame(height: 70, alignment: .bottom)
                                                            .clipped()
                                                            .overlay {
                                                                Group {
                                                                    HStack(spacing: 10) {
                                                                        VStack(alignment: .leading, spacing: 10) {
                                                                            Text("Username")
                                                                                .font(.system(size: 20, weight: .bold))
                                                                                .foregroundColor(.white)
                                                                            Text("Dr. Sachin Sharma")
                                                                                .font(.system(size: 14))
                                                                                .foregroundColor(.white)
                                                                        }
                                                                        Spacer()
                                                                        
                                                                        Text("22d")
                                                                            .font(.system(size: 14, weight: .semibold))
                                                                            .foregroundColor(.white)
                                                                    }.padding()
                                                                }
                                                            }
                                                    }
                                                }
                                            }
                                    }
                                    
                                    
                                }
                            }.padding(.horizontal)
                        }.padding(.bottom, 50)
                    }
                }
                .fullScreenCover(isPresented: $showPreview, onDismiss: nil) {
                    upload
                }
            }.background(Color(.init(white: 0.95, alpha: 1)))
                .navigationTitle("Medical History")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            //show image picker
                            showPreview.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        
                    }
                }
        }
        
    }
    
    private var upload: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            VStack {
                                if let image = image {
                                    VStack {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(10)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 300)
                                        
                                    }
                                } else {
                                    VStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.gray.opacity(0.25))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 300)
                                            .overlay {
                                                VStack {
                                                    Button {
                                                        showImagePicker.toggle()
                                                    } label: {
                                                        Text("Select Document")
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Disease")
                                TextField("Name", text: $disease)
                                    .padding()
                                    .background(.black.opacity(0.05))
                                    .cornerRadius(10)
                                
                                Text("Prescribed by")
                                TextField("Name", text: $doctor)
                                    .padding()
                                    .background(.black.opacity(0.05))
                                    .cornerRadius(10)
                                
                                Text("Hospital/Clinic Name")
                                TextField("clinic", text: $clinic)
                                    .padding()
                                    .background(.black.opacity(0.05))
                                    .cornerRadius(10)
                                Text("Location")
                                TextField("location", text: $location)
                                    .padding()
                                    .background(.black.opacity(0.05))
                                    .cornerRadius(10)
                                
                                
                            }.padding(.vertical)
                            
                        }
                    }
                    Button {
                        //
                    } label: {
                        Text("Upload")
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                        
                            .background(Color("darkAcc"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        
                    }
                }
                .padding()
                
            }.edgesIgnoringSafeArea(.horizontal)
                .edgesIgnoringSafeArea(.bottom)
            
                .sheet(isPresented: $showImagePicker) {
                    imagePicker(image: $image)
                }
                .navigationTitle("Upload Document")
                .navigationBarTitleDisplayMode(.inline)
            
            
            
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            showPreview.toggle()
                        } label: {
                            Text("Close")
                        }
                    }
                }
        }
    }
}

struct medicalHistory_Previews: PreviewProvider {
    static var previews: some View {
        medicalHistory()
    }
}


struct preview: View {
    var body: some View {
        Text("Test")
    }
}
