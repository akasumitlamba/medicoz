//
//  testU.swift
//  medicoz
//
//  Created by Sachin Sharma on 05/04/23.
//

import SwiftUI
import Firebase
import CoreLocation



struct cView: View {
    @ObservedObject var locationManager = LocationManager()

    var body: some View {
//        VStack {
//            if let location = $locationManager.$userLocation.wrappedValue {
//                Text("Latitude: \(location.coordinate.latitude)")
//                Text("Longitude: \(location.coordinate.longitude)")
//                Button(action: {
//                    // Store location in Firebase Firestore
//                    let db = Firestore.firestore()
//                    let userLocation = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//                    db.collection("users").document("current_user_document_id").setData(["location": userLocation], merge: true) { error in
//                        if let error = error {
//                            print("Error storing location: \(error.localizedDescription)")
//                        } else {
//                            print("Location stored successfully!")
//                        }
//                    }
//                }) {
//                    Text("Store Location")
//                }
//            } else {
//                Text("Fetching location...")
//            }
//        }
        Text("Hello")
    }
}


struct cView_Previews: PreviewProvider {
    static var previews: some View {
        cView()
    }
}

