//
//  doctorHomeView.swift
//  medicoz
//
//  Created by Sachin Sharma on 02/04/23.
//

import SwiftUI
import Firebase

struct doctorHomeView: View {
    
    @State var showDocuments = false
    //@Binding var selectedTab: Int
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    homeScreenHeader()

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


struct doctorHeader: View {
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

struct doctorHomeView_Previews: PreviewProvider {
    static var previews: some View {
        doctorHomeView()
    }
}
