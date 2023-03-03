//
//  LocationViewModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/16/22.
//

import SwiftUI
import MapKit
import Firebase
import CoreLocation


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.first
        fetchCountryAndCity(for: locations.first)
        if Auth.auth().currentUser?.uid == nil {
            print("Current usre is nil")
            return
        }
        Firestore.firestore().collection("users_v2").document(Auth.auth().currentUser!.uid).updateData(
            [
//                "longitude" : "\(String(lastSeenLocation!.coordinate.longitude))",
//                "latitude" : "\(String(lastSeenLocation!.coordinate.latitude))"
                "long" : lastSeenLocation!.coordinate.longitude,
                "lat" : lastSeenLocation!.coordinate.latitude

            ]
            )
    }

    func fetchCountryAndCity(for location: CLLocation?) {
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.currentPlacemark = placemarks?.first
        }
    }
}
