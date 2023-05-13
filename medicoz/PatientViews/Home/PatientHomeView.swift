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
    @State var showDocuments = false
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    homeScreenHeader()
                    ScrollView(showsIndicators: false) {
                        VStack {
                            //catagory
                            catagory()
                            
                            //Document Locker Banner Start
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
                                                    
                                                    NavigationLink(destination: medicalHistory()){
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
                            //Document Locker Banner End
                            
                            //Upcoming Appointments Start
                            upcomingAppointments()
                            
                            //Nearby Doctors Start
                            nearbyDoctors()
                            //Nearby Doctors End
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    //Scroller End
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}


struct PatientHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}



struct catagory: View {
    
    @ObservedObject private var viewModel = DataManager()
    
    let catagory: [catagoryModel] = [
        .init(id: 0, title: .Hospital, image: "hospital", color: "1"),
        .init(id: 1, title: .Consultation, image: "consultation1", color: "2"),
        .init(id: 2, title: .Recipe, image: "recipe", color: "3"),
        .init(id: 3, title: .Appointment, image: "appointment3", color: "4"),
    ]
    
    var body: some View {
        HStack(spacing: 20) {
            NavigationLink(destination: Text("Hello")) {
                VStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.white)
                        .frame(width: 70, height: 70)
                        .shadow(radius: 5)
                        .overlay {
                            Image("hospital")
                                .resizable()
                                .scaledToFill()
                                .clipped()
                            
                                .frame(width: 50, height: 50)
                        }
                }
                
            }
            
            //have to make this correct
            NavigationLink(destination: doctorsList()) {
                VStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.white)
                        .frame(width: 70, height: 70)
                        .shadow(radius: 5)
                        .overlay {
                            Image("consultation1")
                                .resizable()
                                .scaledToFill()
                                .clipped()
                            
                                .frame(width: 45, height: 45)
                        }
                }
            }
            
            NavigationLink(destination: medicalHistory()) {
                VStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.white)
                        .frame(width: 70, height: 70)
                        .shadow(radius: 5)
                        .overlay {
                            Image("recipe")
                                .resizable()
                                .scaledToFill()
                                .clipped()
                            
                                .frame(width: 65, height: 65)
                        }
                }
            }

            
            NavigationLink(destination: Text("Hello")) {
                VStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.white)
                        .frame(width: 70, height: 70)
                        .shadow(radius: 5)
                        .overlay {
                            Image("appointment3")
                                .resizable()
                                .scaledToFill()
                                .clipped()
                            
                                .frame(width: 50, height: 50)
                        }
                }
            }
        }
        .padding()
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

//done with ui part just have to connect to database
struct nearbyDoctors: View {
    @ObservedObject private var viewModel = DataManager()
    var body: some View {
        VStack {
            NavigationLink(destination: nearbyDoctorsFullView()) {
                HStack {
                    Text("Nearby Doctors")
                        .padding()
                        .font(.title3)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .symbolRenderingMode(.monochrome)
                        .padding()
                }
            }
            
            nearDoctorList()
            
        }
    }
}

struct nearDoctorList: View {
    var body: some View {
        ZStack {
            VStack{
                VStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 90)
                        .overlay {
                            HStack(spacing: 10) {
                                Image("myImage")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 55, height: 55)
                                    .padding(8)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Dr. Karl Batchelor")
                                        .font(.system(size: 17, weight: .bold))
                                    Text("Endocrinologists")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.lightGray))
                                }
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
                    }
                }
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 90)
                    .overlay {
                        HStack(spacing: 10) {
                            Image("myImage")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 55, height: 55)
                                .padding(8)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Dr. Karl Batchelor")
                                    .font(.system(size: 17, weight: .bold))
                                Text("Endocrinologists")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }
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
                    }
            }.padding(.horizontal)
        }
    }
}

struct nearbyDoctorsFullView: View {
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    nearDoctorList()
                }
                Spacer()
            }
        }
    }
}

