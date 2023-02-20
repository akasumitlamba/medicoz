//
//  appointmentCard.swift
//  medicoz
//
//  Created by Sachin Sharma on 24/01/23.
//

import SwiftUI

let doctors: appointmentModel = appointmentModel(id: 1, title: .Api, image: "mascot",type: "Haddi", time: "thu", color: "1")

struct appointmentCard: View {
    let catagory: appointmentModel
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 5){
                Image(catagory.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 110)
                    .foregroundColor(.blue)
                
                Text(catagory.title.rawValue)
                    .fontWeight(.bold)
                    .font(.system(.title3))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .frame(width: 175, height: 200, alignment: .center)
            .background(Color(catagory.color))
            .cornerRadius(30)
            .padding()
        }
        .frame(width: 175, height: 250, alignment: .center)
        .shadow(radius: 5, x: 5, y: 5)
    }
}

struct appointmentCard_Previews: PreviewProvider {
    static var previews: some View {
        appointmentCard(catagory: doctors)
    }
}
