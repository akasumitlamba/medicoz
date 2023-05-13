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
import SDWebImageSwiftUI
import FirebaseFirestoreSwift



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
    @State private var anyDocument = false
    @State private var isLoader = false
    
    @ObservedObject private var viewModel = documentModel()
    
    @State private var documents: [DocumentSnapshot] = [] // Store fetched documents
    
    
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            if isLoader {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2).padding(20)
            }
            else {
                if anyDocument {
                    VStack {
                        ScrollView {
                            ForEach(documents, id: \.documentID) { document in
                                NavigationLink {
                                    //
                                } label: {
                                    VStack {
                                        Spacer()
                                        VStack {
                                            WebImage(url: URL(string: document["documentUrl"] as? String ?? ""))
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
                                                                                Text(document["disease"] as? String ?? "")
                                                                                    .font(.system(size: 20, weight: .bold))
                                                                                    .foregroundColor(.white)
                                                                                HStack(spacing: 5) {
                                                                                    Text("Dr.")
                                                                                        .font(.system(size: 14))
                                                                                        .foregroundColor(.white)
                                                                                    Text(document["doctor"] as? String ?? "")
                                                                                        .font(.system(size: 14))
                                                                                        .foregroundColor(.white)
                                                                                }
                                                                            }
                                                                            Spacer()
                                                                            if let timestamp = document["timestamp"] as? Timestamp {
                                                                                Text(timeAgo(timestamp: timestamp))
                                                                                    .font(.system(size: 14, weight: .semibold))
                                                                                    .foregroundColor(.white)
                                                                            }
                                                                            
                                                                           
                                                                        }.padding()
                                                                    }
                                                                }
                                                        }
                                                    }
                                                }
                                        }
                                    }.padding(.horizontal)
                                }
                                
                            }.padding(.bottom, 50)
                        }
                        .fullScreenCover(isPresented: $showPreview, onDismiss: nil) {
                            upload
                        }
                        .background(Color(.init(white: 0.95, alpha: 1)))
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
                    }
                    
                }
                else {
                    Text("No Documents Found")
                        .font(.title)
                        .foregroundColor(.black.opacity(0.5))
                }
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    func dateString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
    
    func timeAgo(timestamp: Timestamp) -> String {
           let formatter = RelativeDateTimeFormatter()
           formatter.unitsStyle = .abbreviated
           return formatter.localizedString(for: timestamp.dateValue(), relativeTo: Date())
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
    
    func fetchData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let db = Firestore.firestore()
        db.collection("medicalDocuments")
            .document(uid)
            .collection("documents")
            .order(by: "timestamp", descending: true) // Order by the "time" field in descending order
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    anyDocument = false
                    return
                }
                self.documents = documents
                anyDocument = true
            }
    }
    
    
    
}

struct medicalHistory_Previews: PreviewProvider {
    static var previews: some View {
        medicalHistory()
    }
}

