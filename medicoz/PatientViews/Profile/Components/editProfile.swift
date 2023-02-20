//
//  editProfile.swift
//  medicoz
//
//  Created by Sachin Sharma on 17/02/23.
//


import SwiftUI
import Firebase
import FirebaseStorage


struct editProfile: View {
    @Environment (\.dismiss) private var dismiss
    
    @State private var showImagePicker = false
    @State private var image: UIImage?
    
    @State private var name = ""
    
    @State private var male = false
    @State private var female = false
    
    @State var birthday: Date = Date()
    @State var gender = ""
    @State var weight = ""
    @State var bg: String = "choose"
    let bgTypes = ["choose","A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
    
    @State var loginStatusMessage = ""
    @State var imageUrl = ""
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @State var patientAccountSetup = true
    @State var doctorAccountSetup = false
    
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color("lightAcc")
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                            .padding(20)
                    }
                    Spacer()
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
                                            )
                                    }
                                }.shadow(radius: 8)
                            }
                        }.padding()
                        
                        //Feilds
                        VStack{
                            
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
                                                .foregroundColor(Color("AccentColor"))
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
                                Text("Weight")
                                    .font(.custom("Poppins-Regular", size: 20))
                                    .padding(.horizontal, 3)
                                
                                TextField("weight", text: $weight)
                                    .frame(width: .infinity, height: 55)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.black.opacity(0.05))
                                    .frame(width: .infinity, height: 55)
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
                            
                        }.padding(.top, 20)
                        
                        //Save Button
                        VStack{
                            Button {
                                persistImageToStorage()
                            } label: {
                                Text("Save")
                                    .foregroundColor(.white)
                                    .font(.custom("Poppins-Regular", size: 20))
                                    .frame(width: 340, height: 55)
                                    .background(Color("AccentColor"))
                                    .cornerRadius(10)
                            }
                        }.padding(.vertical, 30)
                    }
                }
                
                .edgesIgnoringSafeArea(.all)
                .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
                    imagePicker(image: $image)
                }
                
            }
        }.edgesIgnoringSafeArea(.all)
        
//        .navigationBarBackButtonHidden().edgesIgnoringSafeArea(.all)
//            .toolbar {
//                Button("Sign Out") {
//                    //TODO: Signout here
//                    do {
//                        try Auth.auth().signOut()
//                        print("Signed Out Successfully!")
//                        dismiss()
//                    } catch {
//                            print("ERROR: Could not sign out!")
//                    }
//                }//.foregroundColor(Color.black)
//            }
        
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing){
//                    //signout logic
//                    Button("Sign Out") {
//                        //TODO: Signout here
//                        do {
//                            try Auth.auth().signOut()
//                            print("Signed Out Successfully!")
//                            dismiss()
//                        } catch {
//                            print("ERROR: Could not sign out!")
//                        }
//                    }.foregroundColor(Color.black)
//                }
//            }
    }
    
    
    
    //Send image to storage
    private func persistImageToStorage() {
        //let filename = UUID().uuidString
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Storage.storage().reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {return}
        ref.putData(imageData, metadata: nil) { metadata, err in
            if err != nil {
                self.loginStatusMessage = "Failed to push image to Storage: \(String(describing: err))"
                return
            }
            ref.downloadURL{ url, err in
                if err != nil {
                    self.loginStatusMessage = "Failed to reterive download url: \(String(describing: err))"
                    return
                }
                self.loginStatusMessage = " Succefully stored image with url: \(url?.absoluteString ?? "")"
                self.imageUrl = "\(url?.absoluteString ?? "")"
                
                guard let url = url else{return}
                self.storeUserInfo(imageProfileUrl: url)
            }
        }
    }
    
    private func storeUserInfo (imageProfileUrl: URL) {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let userData = ["uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        Firestore.firestore().collection("patients")
            .document(uid).setData(userData) { error in
                if let error = error {
                    print(error)
                    self.loginStatusMessage = "\(error)"
                    return
                }
            }
        
    }
    
    func handelSaveTapped(){
        persistImageToStorage()
    }
}

struct editProfile_Previews: PreviewProvider {
    static var previews: some View {
        editProfile()
    }
}
