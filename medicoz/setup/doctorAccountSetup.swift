//
//  doctorAccountSetup.swift
//  medicoz
//
//  Created by Sachin Sharma on 01/04/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct doctorAccountSetup: View {
    @Environment (\.dismiss) private var dismiss
    @StateObject var sessionManager = SessionManager()
    
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    
    
    @State private var male = false
    @State private var female = false
    @State private var name = ""
    @State var birthday: Date = Date()
    @State var gender = ""
    @State var regNo: String = ""
    @State var bg: String = "choose"
    
    let bgTypes = ["choose","A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
    
    @State var loginStatusMessage = ""
    @State var imageUrl = ""
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @State var showAlert = false
    @State var alertMessages = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
                        //Image
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
                        
                        //Feilds
                        VStack(alignment: .leading){
                            
                            //Name
                            VStack(alignment: .leading) {
                                Text("Name")
                                    .font(.custom("Poppins-Regular", size: 20))
                                
                                TextField("your name", text: $name)
                                    .autocorrectionDisabled(true)
                                    .padding()
                                    .frame(width: 340, height: 55)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .padding(.vertical, 8)
                            }.padding(.vertical, 5)
                            
                            //DOB
                            VStack(alignment: .leading) {
                                Text("Date of Birth")
                                    .font(.custom("Poppins-Regular", size: 20))
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.05))
                                    .frame(width: 340, height: 55)
                                    .padding(.vertical, 8)
                                    .overlay(
                                        HStack{
                                            Text(dateFormatter.string(from: birthday))
                                                .foregroundColor(.black.opacity(0.3))
                                                .padding()
                                            Spacer()
                                            Image(systemName: "calendar")
                                                .font(.title)
                                                .overlay{ //MARK: Place the DatePicker in the overlay extension
                                                    DatePicker(
                                                        "",
                                                        selection: $birthday,
                                                        displayedComponents: [.date]
                                                    )
                                                    .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
                                                }
                                        }.padding(.vertical).padding(.trailing)
                                    )
                                
                                
                            }.padding(.vertical, 5)
                            
                            //Gender
                            VStack(alignment: .leading){
                                Text("Gender")
                                    .font(.custom("Poppins-Regular", size: 20))
                                
                                HStack{
                                    Button {
                                        male = true
                                        female = false
                                        if male {
                                            gender = "male"
                                        }
                                    } label: {
                                        Text("Male")
                                            .frame(width: 162, height: 55)
                                            .foregroundColor(male ? Color.white : Color.black.opacity(0.3))
                                            .background(male ? Color("AccentColor") : Color.clear)
                                    }
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .padding(.vertical, 8)
                                    
                                    Button {
                                        female = true
                                        male = false
                                        if female {
                                            gender = "female"
                                        }
                                    } label: {
                                        Text("Female")
                                            .frame(width: 162, height: 55)
                                            .foregroundColor(female ? Color.white : Color.black.opacity(0.3))
                                            .background(female ? Color("AccentColor") : Color.clear)
                                    }
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .padding(.vertical, 8)
                                    
                                }
                            }.frame(width: 340).padding(.vertical, 5)
                            
                            //Weight
                            HStack{
                                Text("Registration No")
                                    .font(.custom("Poppins-Regular", size: 20))
                                    .padding(.horizontal, 3)
                                
                                TextField("regNo", text: $regNo)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.black.opacity(0.05))
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(10)
                                
                            }.frame(width: 340, height: 55).padding(.vertical, 13)
                            
                            //Blood Group
                            HStack{
                                Text("Blood Group")
                                    .font(.custom("Poppins-Regular", size: 20))
                                    .padding(.horizontal, 3)
                        
                                    HStack{
                                        Picker("Choose", selection: $bg) {
                                            ForEach(bgTypes, id: \.self) { type in
                                                Text(type)
                                                    .tag(type)
                                            }
                                        }.padding()
                                        Spacer()
                                    }.frame(width: 210, height: 55)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .padding(.vertical, 8)
                                
                                
                            }.frame(width: 340, height: 55).padding(.vertical, 13)
                            
                        }.padding(.top, 40)
                        
                        //Save Button
                        VStack{
                            Button {
                                if !name.isEmpty && !gender.isEmpty && !regNo.isEmpty && bg != "choose" {
                                    uploadData()
                                }
                            } label: {
                                Text("Save")
                                    .foregroundColor(.white)
                                    .font(.custom("Poppins-Regular", size: 20))
                                    .frame(width: 340, height: 55)
                                    .background(Color("AccentColor"))
                                    .cornerRadius(10)
                            }.disabled(name.isEmpty && regNo.isEmpty && gender.isEmpty && bg.isEmpty)
                        }.padding(.vertical, 30)
                    }
                    .alert(isPresented: $showAlert) {
                        getAlert()
                    }
                }.edgesIgnoringSafeArea(.all)
                    .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
                        imagePicker(image: $image)
                    }
            }.navigationBarBackButtonHidden(true)
                .toolbar {
                    Button("Sign Out") {
                        //TODO: Signout here
                        do {
                            try Auth.auth().signOut()
                            print("Signed Out Successfully!")
                            dismiss()
                        } catch {
                                print("ERROR: Could not sign out!")
                        }
                    }
            }
        }
        
    }
    
    
    private func getAlert() -> Alert {
        return Alert(title: Text(alertMessages), dismissButton: .default(Text("OK")))
    }
    
    private func uploadData() {
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        guard let image = image else {
            print("Image not found")
            showAlert.toggle()
            alertMessages = ("Image not found")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            showAlert.toggle()
            alertMessages = ("Image Error")
            return
        }
        
        let storageRef = Storage.storage().reference().child("profilePicture/\(UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = storageRef.putData(imageData, metadata: metadata)
        
        uploadTask.observe(.success) { snapshot in
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "")")
                    showAlert.toggle()
                    alertMessages = "\(String(describing: error?.localizedDescription))"
                    return
                }
                
                
                let data = ["name": name, "imageURL": downloadURL.absoluteString, "birthday": birthday, "gender": gender, "regNo": regNo, "bloodGroup": bg] as [String : Any]
                Firestore.firestore().collection("doctors").document(uid).setData(data) { error in
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                        showAlert.toggle()
                        alertMessages = "\(String(describing: error.localizedDescription))"
                    } else {
                        print("Document added successfully")
                        sessionManager.isLoading = false
                        sessionManager.doctorDocumentFound = true
                        sessionManager.doctorDocumentNotFound = false
                    }
                }
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Error uploading image: \(error.localizedDescription)")
                showAlert.toggle()
                alertMessages = "Error uploading image: \(error.localizedDescription)"
                
            }
        }
        
    }
    
}

struct doctorAccountSetup_Previews: PreviewProvider {
    static var previews: some View {
        doctorAccountSetup()
    }
}
