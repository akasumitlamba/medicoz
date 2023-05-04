//
//  medicalHistory.swift
//  medicoz
//
//  Created by Sachin Sharma on 24/01/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Foundation


//class documentManager {
//
//    static let shared = documentManager()
//    private let db = Firestore.firestore()
//
//    func fetchMedicalDocuments(completion: @escaping ([medicalDocument]?, Error?) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            completion(nil, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not logged in"]))
//            return
//        }
//
//        db.collection("medicalDocuments")
//            .document(uid)
//            .collection("documents")
//            .order(by: "timestamp", descending: true)
//            .getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    completion(nil, error)
//                    return
//                }
//
//                var documents = [MedicalDocument]()
//                for document in querySnapshot!.documents {
//                    let data = document.data()
//                    if let documentUrl = data["documentUrl"] as? String,
//                       let disease = data["disease"] as? String,
//                       let doctor = data["doctor"] as? String,
//                       let clinic = data["clinic"] as? String,
//                       let location = data["location"] as? String,
//                       let timestamp = data["timestamp"] as? Timestamp {
//                        let medicalDocument = MedicalDocument(documentUrl: documentUrl, disease: disease, doctor: doctor, clinic: clinic, location: location, timestamp: timestamp.dateValue())
//                        documents.append(medicalDocument)
//                    }
//                }
//
//                completion(documents, nil)
//            }
//    }
//
//}

struct Document {
    var id: String
    var data: [String: Any]
}

struct medicalHistory: View {
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    @State private var showPreview = false
    @State private var disease = ""
    @State private var doctor = ""
    @State private var clinic = ""
    @State private var location = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var showToast = false
    @State private var isLoading = false
    @State private var isButtonPressed = false
    
    let db = Firestore.firestore()
    @State var documents = [Document]()
    
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(documents, id: \.id) { document in
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
                                                                            Text(document.data["disease"] as? String ?? "")
                                                                                .font(.system(size: 20, weight: .bold))
                                                                                .foregroundColor(.white)
                                                                            Text(document.data["doctor"] as? String ?? "")
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
                .alert(alertMessage, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
                .onAppear {
                    db.collection("collection_name").getDocuments { (snapshot, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        guard let documents = snapshot?.documents else {
                            print("No documents found.")
                            return
                        }
                        
                        self.documents = documents.map { Document(id: $0.documentID, data: $0.data()) }
                    }
                }
        }
        
    }
    
    private var upload: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.3))
                        .frame(width: 150, height: 80)
                        .overlay {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(2).padding(20)
                        }
                }
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            VStack {
                                if let image = image {
                                    Button {
                                        showImagePicker.toggle()
                                    } label: {
                                        VStack {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(10)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 300)
                                            
                                        }
                                    }
                                    
                                } else {
                                    VStack {
                                        VStack {
                                            Button {
                                                showImagePicker.toggle()
                                            } label: {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(.gray.opacity(0.25))
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 300)
                                                    .overlay {
                                                        HStack(spacing: 5){
                                                            Image(systemName: "plus.circle")
                                                            Text(" Select Document")
                                                        }
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
                        if disease.isEmpty || doctor.isEmpty || clinic.isEmpty || location.isEmpty{
                            showAlert.toggle()
                            isButtonPressed = false
                            alertMessage = "Please fill all details"
                        } else {
                            if !isButtonPressed {
                                isButtonPressed = true
                                isLoading = true
                                uploadData()
                            }
                        }
                        
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
            
                .alert(alertMessage, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
            
            
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
    
    
    
    
    private func uploadData() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let image = image else {
            print("Image not found")
            showAlert.toggle()
            isButtonPressed = false
            alertMessage = "Image not found"
            isLoading = false
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            showAlert.toggle()
            isButtonPressed = false
            alertMessage = "Error converting image to data"
            isLoading = false
            return
        }
        
        let storageRef = Storage.storage().reference().child("medicalDocuments/\(UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = storageRef.putData(imageData, metadata: metadata)
        
        uploadTask.observe(.success) { snapshot in
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "")")
                    showAlert.toggle()
                    isButtonPressed = false
                    alertMessage = "Error getting download URL"
                    isLoading = false
                    return
                }
                
                let documentData = ["documentUrl": downloadURL.absoluteString,
                                    "disease": disease,
                                    "doctor": doctor,
                                    "clinic": clinic,
                                    "location": location,
                                    "timestamp": Timestamp()] as [String : Any]
                
                Firestore.firestore()
                    .collection("medicalDocuments")
                    .document(uid)
                    .collection("documents")
                    .addDocument(data: documentData) { error in
                        if let error = error {
                            print("Error adding document: \(error.localizedDescription)")
                            showAlert.toggle()
                            isButtonPressed = false
                            alertMessage = "Error adding document: \(error.localizedDescription)"
                            isLoading = false
                        } else {
                            print("Document added successfully")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isLoading = false
                                showAlert.toggle()
                                isButtonPressed = false
                                alertMessage = "Added Successfully"
                                presentationMode.wrappedValue.dismiss()
                                showPreview.toggle()
                            }
                        }
                    }
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Error uploading image: \(error.localizedDescription)")
                showAlert.toggle()
                isButtonPressed = false
                alertMessage = "Error uploading image: \(error.localizedDescription)"
                isLoading = false
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
