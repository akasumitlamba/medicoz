//
//  PatientHomeView.swift
//  medicoz
//
//  Created by Sachin Sharma on 19/01/23.
//

import SwiftUI
import Firebase

struct PatientHomeView: View {
    @Environment (\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    Header()

                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.gray)
                        .frame(height: 1)

                    // Divider()
                    Scroller()
                }
            }.edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
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
        PatientHomeView()
    }
}

struct Header: View {
    @Environment (\.dismiss) private var dismiss
    @State var logoutAlert = false
    @State var alertMessage = ""
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 80, height: 80)
                    .clipped()
                VStack(alignment: .leading) {
                    Text("Welcome!")
                        .frame(alignment: .leading)
                        .clipped()
                        .font(.title2)
                        .foregroundColor(Color("lightText"))
                    Text("Sachin Sharma")
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

struct Scroller: View {
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                VStack {
                    //Most Popular
                    catagory()
                    //Upcoming Appointments
                    upcomingAppointments()
                    //Nearby Doctors
                    nearbyDoctors()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

struct catagory: View {
    
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 20) {
                    ForEach(catagory, id: \.id){ post in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("lightAcc"))
                            .frame(width: 340, height: 150)
                    }
                }
            }
            .padding()
        }
    }
}

struct nearbyDoctors: View {
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
