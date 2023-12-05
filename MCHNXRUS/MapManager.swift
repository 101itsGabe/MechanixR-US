//
//  MapManager.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 12/4/23.
//

import Foundation
import CoreLocation
import MapKit

class MapManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var mxManager: MXManager?
    @Published var locationManager = CLLocationManager()
    @Published var region: MKCoordinateRegion?
    @Published var goecoder = CLGeocoder()
    @Published var curAddress: String?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            userLocation = location
            region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        }
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func getLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if let userLocation = userLocation{
            region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        }
    }
    
    func getAddress(){
        if let curLat = userLocation?.latitude, let curLong = userLocation?.longitude{
            
            goecoder.reverseGeocodeLocation(CLLocation(latitude: curLat, longitude: curLong)) { placemarks, error in
                
                guard let placemark = placemarks?.first else {
                    print(error.debugDescription)
                    return
                }
                
                if let addy = placemark.name{
                    self.curAddress = addy
                }
                
            }
        }
    }
}
