//
//  LocationManager.swift
//  medicoz
//
//  Created by Sachin Sharma on 06/04/23.
//

import SwiftUI

import SwiftUI
import CoreLocation
import MapKit

struct locationView: View {
    @StateObject var locationManager = LocationManager()
    @State private var nearbyUsers = [Userr]()
    
    var body: some View {
        VStack {
//            MapView(nearbyUsers: $nearbyUsers, centerCoordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D())
//                .edgesIgnoringSafeArea(.all)
            
            List(nearbyUsers) { userr in
                Text(userr.name)
            }
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
        // Query backend service to get list of nearby users
        // ...
    }
}

struct MapView: UIViewRepresentable {
    @Binding var nearbyUsers: [Userr]
    var centerCoordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update map annotations for nearby users
        mapView.removeAnnotations(mapView.annotations)
        let annotations = nearbyUsers.map { userr -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = userr.coordinate
            annotation.title = userr.name
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
}

struct Userr: Identifiable {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let id = UUID().uuidString
}


struct LocationManager_Previews: PreviewProvider {
    static var previews: some View {
        locationView()
    }
}
