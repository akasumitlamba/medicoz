//
//  appointmentView.swift
//  medicoz
//
//  Created by Sachin Sharma on 24/01/23.
//

import SwiftUI

struct appointmentView: View {
    
    private var navBar: some View {
        HStack(spacing: 16) {
            
            Image(systemName: "person.fill")
                .font(.system(size: 34, weight: .heavy))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("USERNAME")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            
            Spacer()
            NavigationLink(destination: mainMessagesView(didSelectNewUser: { item
                in
                print(item.email)
            })) {
                Image(systemName: "message.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color("AccentColor"))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                navBar
                Spacer()
                Text("Hello World!")
            }
            
        }
    }
}

struct appointmentView_Previews: PreviewProvider {
    static var previews: some View {
        appointmentView()
    }
}
