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
    @Environment (\.presentationMode) var presentationMode
    
    @StateObject var sessionManager = SessionManager()
    
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    
    
    @State private var male = false
    @State private var female = false
    @State private var name = ""
    @State var birthday: Date = Date()
    @State var gender = ""
    @State var regNo: String = ""
    @State var spec = ""
    
    @State var loginStatusMessage = ""
    @State var imageUrl = ""
    @AppStorage ("userRole") var userRole: String = ""
    @AppStorage ("uid") var userID: String = ""
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @State var showAlert = false
    @State var alertMessage = ""
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                if sessionManager.isLoading {
                    ZStack {
                        Color.clear
                            .background(
                                Color.white
                                    .opacity(0.2)
                                    .blur(radius: 10)
                            )
                        VStack {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(3).padding(20)
                        }
                    }
                }
                
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
                            
                            //Registration No
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
                            
                            //specialization
                            HStack{
                                Text("Specialization")
                                    .font(.custom("Poppins-Regular", size: 20))
                                    .padding(.horizontal, 3)
                                
                                TextField("specialization", text: $spec)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.black.opacity(0.05))
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(10)
                                
                            }.frame(width: 340, height: 55).padding(.vertical, 13)
                            
                            
                            
                        }.padding(.top, 40)
                        
                        //Save Button
                        VStack{
                            Button {
                                if name.isEmpty {
                                    showAlert.toggle()
                                    alertMessage = ("Enter Your Name")
                                }
                                userRole = "doctor"
                                sessionManager.isLoading = true
                                registerUser(email: email, password: password, role: userRole) { result in
                                    switch result {
                                    case .success:
                                        break
                                    case .failure(let error):
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    }
                                }
                                
                            } label: {
                                Text("Create Account")
                                    .foregroundColor(.white)
                                    .font(.custom("Poppins-Regular", size: 20))
                                    .frame(width: 340, height: 55)
                                    .background(Color("AccentColor"))
                                    .cornerRadius(10)
                            }.disabled(name.isEmpty && regNo.isEmpty && gender.isEmpty && spec.isEmpty)
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
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
    }
    
    
    private func getAlert() -> Alert {
        return Alert(title: Text(alertMessage), dismissButton: .default(Text("OK")))
    }
    
    func registerUser(email: String, password: String, role: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {//login error occured
                completion(.failure(error))
                print("SignUp Error: \(error.localizedDescription)")
                alertMessage = "SignUp Error: \(error.localizedDescription)"
                showAlert = true
            }
            
            else if (result?.user) != nil {
                uploadData()
            }
        }
    }
    
    private func uploadData() {
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let randomNumber = abs(UUID().hashValue) % 1000000000
        let numericId = String(format: "%010d", randomNumber)
        
        guard let image = image else {
            print("Image not found")
            showAlert.toggle()
            alertMessage = ("Image not found")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            showAlert.toggle()
            alertMessage = ("Image Error")
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
                    alertMessage = "\(String(describing: error?.localizedDescription))"
                    return
                }
                
                
                let data = ["email": email,
                            "role": userRole,
                            "uid": numericId,
                            "name": name,
                            "profileImage": downloadURL.absoluteString,
                            "birthday": birthday,
                            "gender": gender,
                            "regNo": regNo,
                            "spec": spec] as [String : Any]
                
                Firestore.firestore().collection("users").document(uid).setData(data) { error in
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                        showAlert.toggle()
                        alertMessage = "\(String(describing: error.localizedDescription))"
                    } else {
                        print("Document added successfully")
                        sessionManager.isLoggedIn = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            sessionManager.isLoading = false
                        }
                        withAnimation {
                            self.userID = uid
                        }
                    }
                }
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Error uploading image: \(error.localizedDescription)")
                showAlert.toggle()
                alertMessage = "Error uploading image: \(error.localizedDescription)"
                
            }
        }
        
    }
    
}

