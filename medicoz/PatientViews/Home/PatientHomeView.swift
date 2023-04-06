//
//  PatientHomeView.swift
//  medicoz
//
//  Created by Sachin Sharma on 19/01/23.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct PatientHomeView: View {
    @Binding var selectedTab: Int
    @State var showDocuments = false
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    patientHeader()

                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.gray)
                        .frame(height: 1)

                    // Divider()
                    
                    //Scroller Start
                    ScrollView(showsIndicators: false) {
                        ZStack {
                            VStack {
                                //Locker Banner Start
                                ZStack {
                                    VStack {
                                        HStack(alignment: .center, spacing: 20) {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color("darkAcc"))
                                                .frame(height: 170)
                                                .overlay(
                                                    HStack {
                                                        VStack(alignment: .leading){
                                                            Text("Your Digital Health Locker")
                                                                .multilineTextAlignment(.leading)
                                                                .foregroundColor(.white)
                                                                .font(.title2)
                                                            Spacer()
                                                            Text("Quickle view your health records")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                            Spacer()
                                                            
                                                            NavigationLink(destination: documentLocker()){
                                                                Text("Click Here")
                                                                    .padding(.horizontal)
                                                                    .padding(.vertical, 10)
                                                                    .background(.white)
                                                                    .cornerRadius(10)
                                                            }
                                                            

                                                        }.padding(.leading).padding(.vertical)
                                                        Spacer()
                                                        Image("pp")
                                                            .resizable()
                                                            //.frame(width: 150, height: 140)
                                                            .scaledToFit()
                                                            .padding(.vertical)
                                                            .padding(.trailing)
                                                    }
                                                )
                                        }.padding()
                                    }
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarHidden(true)
                                }
                                //Locker banner End
                                
                                //Catagory Start
                                //catagory()
                                //Catagory End
                                
                                //Upcoming Appointments Start
                                upcomingAppointments()
                                //Upcoming Appointments End
                                
                                //Nearby Doctors Start
                                nearbyDoctors()
                                //Nearby Doctors End
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    //Scroller End
                }
            }.edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
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
}

struct PatientHomeView_Previews: PreviewProvider {
    static var previews: some View {
        medication()
    }
}

struct patientHeader: View {
    @Environment (\.dismiss) private var dismiss
    @ObservedObject private var viewModel = DataManager()
    @State var logoutAlert = false
    @State var alertMessage = ""
    var body: some View {
        VStack {
            HStack {
                WebImage(url: URL(string: viewModel.userData?.profileImage ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipped()
                    .cornerRadius(70)
                    .overlay(RoundedRectangle(cornerRadius: 70)
                        .stroke(Color(.label), lineWidth: 1)
                    )
                    .shadow(radius: 5, x: 5, y: 5)
                VStack(alignment: .leading) {
                    Text("Welcome!")
                        .frame(alignment: .leading)
                        .clipped()
                        .font(.title2)
                        .foregroundColor(Color("lightText"))
                    Text("\(viewModel.userData?.name ?? "")")
                        .font(.title)
                        .foregroundColor(Color("darkText"))
                    
                }
                .padding()
                .frame(alignment: .leading)
                .clipped()
                Spacer()
            }
            .padding()
            .padding(.top, 50)
        }.alert(isPresented: $logoutAlert) {
            getAlert()
        }
    }
    
    private func getAlert() -> Alert {
        return Alert(
            title: Text("Log Out"),
            message: Text("Are you sure?"),
            primaryButton: .destructive(Text("Log Out"), action: {
                //TODO: Signout here
                do {
                    try Auth.auth().signOut()
                    print("Signed Out Successfully!")
                    dismiss()
                } catch {
                        print("ERROR: Could not sign out!")
                }
            }),
            secondaryButton: .cancel()
        )
    }

}

struct catagory: View {
    
    @ObservedObject private var viewModel = DataManager()
    let catagory: [catagoryModel] = [
        .init(id: 0, title: .Diagnostic, image: "mascot", color: "1"),
        .init(id: 1, title: .Shots, image: "mascot", color: "2"),
        .init(id: 2, title: .Consultation, image: "mascot", color: "3"),
        .init(id: 3, title: .Ambulance, image: "mascot", color: "4"),
        .init(id: 4, title: .Nurse, image: "mascot", color: "5"),
        .init(id: 5, title: .Medical_History, image: "mascot", color: "6")
    ]
    
    let items = [
            ("Item 1", "View 2"),
            ("Item 2", "View 2"),
            ("Item 3", "View 3"),
            ("Item 4", "View 4"),
            ("Item 5", "View 5"),
            ("Item 6", "View 6")
        ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Catagory")
                    .padding()
                    .font(.title3)
                Spacer()
                Image(systemName: "chevron.right")
                    .symbolRenderingMode(.monochrome)
                    .padding()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center, spacing: 20) {
                    ForEach(items, id: \.0) { item in
                        NavigationLink(
                            destination: Text(item.1),
                            label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("lightAcc"))
                                    .frame(width: 140, height: 170)
                                    .overlay(
                                        Text(item.0)
                                            .foregroundColor(.blue)
                                    )
                            }
                        )
                    }
                    
                    
                    ForEach(catagory, id: \.id){ post in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("lightAcc"))
                            .frame(width: 140, height: 170)
                        
                    }
                }
            }
            .padding()
        }
    }
}

struct upcomingAppointments: View {
    @ObservedObject private var viewModel = DataManager()
    
    var body: some View {
        VStack {
            HStack {
                Text("Upcoming Appointments")
                    .padding()
                    .font(.title3)
                Spacer()
                Image(systemName: "chevron.right")
                    .symbolRenderingMode(.monochrome)
                    .padding()
            }
            .frame(alignment: .leading)
            .clipped()
            HStack(alignment: .center, spacing: 20) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("lightAcc"))
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

struct nearbyDoctors: View {
    @ObservedObject private var viewModel = DataManager()
    var body: some View {
        VStack {
            HStack {
                Text("Nearby Doctors")
                    .padding()
                    .font(.title3)
                Spacer()
                Image(systemName: "chevron.right")
                    .symbolRenderingMode(.monochrome)
                    .padding()
            }
            VStack {
                HStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .clipped()
                    VStack {
                        Text("Dr. Karl Batchelor")
                        Text("Endocrinologists")
                    }
                    .padding(.horizontal)
                    Spacer()
                    Capsule(style: .continuous)
                        .fill(Color("Accent"))
                        .frame(width: 100, height: 34)
                        .clipped()
                        .overlay {
                            HStack {
                                Image(systemName: "location.circle")
                                    .symbolRenderingMode(.monochrome)
                                Text("500 m")
                            }
                            .padding(4)
                        }
                }
                .padding(.horizontal)
                Divider()
                HStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .clipped()
                    VStack {
                        Text("Dr. Karl Batchelor")
                        Text("Endocrinologists")
                    }
                    .padding(.horizontal)
                    Spacer()
                    Capsule(style: .continuous)
                        .fill(Color("Accent"))
                        .frame(width: 100, height: 34)
                        .clipped()
                        .overlay {
                            HStack {
                                Image(systemName: "location.circle")
                                    .symbolRenderingMode(.monochrome)
                                Text("500 m")
                            }
                            .padding(4)
                        }
                }
                .padding(.horizontal)
                Divider()
                HStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .clipped()
                    VStack {
                        Text("Dr. Karl Batchelor")
                        Text("Endocrinologists")
                    }
                    .padding(.horizontal)
                    Spacer()
                    Capsule(style: .continuous)
                        .fill(Color("Accent"))
                        .frame(width: 100, height: 34)
                        .clipped()
                        .overlay {
                            HStack {
                                Image(systemName: "location.circle")
                                    .symbolRenderingMode(.monochrome)
                                Text("500 m")
                            }
                            .padding(4)
                        }
                }
                .padding(.horizontal)
                Divider()
                HStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .clipped()
                    VStack {
                        Text("Dr. Karl Batchelor")
                        Text("Endocrinologists")
                    }
                    .padding(.horizontal)
                    Spacer()
                    Capsule(style: .continuous)
                        .fill(.green.opacity(0.75))
                        .frame(width: 100, height: 34)
                        .clipped()
                        .overlay {
                            HStack {
                                Image(systemName: "location.circle")
                                    .symbolRenderingMode(.monochrome)
                                Text("500 m")
                            }
                            .padding(4)
                        }
                }
                .padding(.horizontal)
                Divider()
            }
        }
    }
}



struct medication: View {
    
    @ObservedObject private var viewModel = DataManager()
    
    let catagory: [catagoryModel] = [
        .init(id: 0, title: .Diagnostic, image: "mascot", color: "1"),
        .init(id: 1, title: .Shots, image: "mascot", color: "2"),
        .init(id: 2, title: .Consultation, image: "mascot", color: "3"),
        .init(id: 3, title: .Ambulance, image: "mascot", color: "4"),
        .init(id: 4, title: .Nurse, image: "mascot", color: "5"),
        .init(id: 5, title: .Medical_History, image: "mascot", color: "6")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Medication")
                    .padding()
                    .font(.title3)
                Spacer()
                Image(systemName: "chevron.right")
                    .symbolRenderingMode(.monochrome)
                    .padding()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 20) {
                    ForEach(catagory, id: \.id){ post in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("lightAcc"))
                            .frame(width: 140, height: 170)
                    }
                }
            }
            .padding()
        }
    }
}
