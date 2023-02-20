//
//  test3.swift
//  medicoz
//
//  Created by Sachin Sharma on 19/02/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct FirebaseUploadView: View {
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    @State private var name: String = ""
    @State private var age: Int = 0
    
    var body: some View {
        VStack {
            VStack{
                Button {
                    showImagePicker.toggle()
                } label: {
                    VStack{
                        if let image = self.image{
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .scaledToFill()
                                .cornerRadius(100)
                        }
                        else {
                            RoundedRectangle(cornerRadius: 64)
                                .fill(Color.white)
                                .frame(width: 130, height: 130)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .foregroundColor(Color.blue)
                                        .frame(width: 100, height: 100)
                                        .padding()
                                )
                        }
                    }.shadow(radius: 8)
                }
            }.padding().padding(.top, 80)
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Stepper("Age: \(age)", value: $age)
                .padding()
            
            Button("Upload") {
                uploadData()
            }
            .padding()
        }.fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
            imagePicker(image: $image)
        }
    }
    
    private func uploadData() {
        guard let image = image else {
            print("Image not found")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            return
        }
        
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = storageRef.putData(imageData, metadata: metadata)
        
        uploadTask.observe(.success) { snapshot in
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "")")
                    return
                }
                
                let data = ["name": name, "age": age, "imageURL": downloadURL.absoluteString]
                Firestore.firestore().collection("users").addDocument(data: data) { error in
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                    } else {
                        print("Document added successfully")
                    }
                }
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Error uploading image: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadImage() {
        // code for loading image from user's photo library
    }
}


struct FirebaseUploadView_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseUploadView()
    }
}
