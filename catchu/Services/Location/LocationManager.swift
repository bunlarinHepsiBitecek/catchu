//
//  LocationManager.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MapKit

protocol LocationManagerDelegate: class {
    func didUpdateLocation()
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var counter = 0
    
    public static let shared = LocationManager()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    weak var delegate: LocationManagerDelegate!
    
    var externalViewInitialize : Bool = false
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        
        guard let locationManager = self.locationManager else {
            return
        }
        
        locationAuthorizationCheck()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = Constants.Map.DistanceFilter
        locationManager.allowsBackgroundLocationUpdates = true // Enable background location updates
        locationManager.pausesLocationUpdatesAutomatically = true // Enable automatic pausing
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization tetiklendi")
//        self.locationAuthorizationCheck()
    }
    
    // MARK: check location auth options
    func locationAuthorizationCheck() {
        let status  = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse :
            break
        case .denied, .restricted:
            self.permissionAlert()
            break
        case .notDetermined :
            locationManager.requestAlwaysAuthorization()
            break
        }
    }
    
    func permissionAlert() {
        AlertViewManager.shared.createAlert(title: LocalizedConstants.Location.LocationServiceDisableTitle, message: LocalizedConstants.Location.LocationServiceDisable, preferredStyle: .alert, actionTitleLeft: LocalizedConstants.Location.Settings, actionTitleRight: LocalizedConstants.Location.Ok, actionStyle: .default, completionHandlerLeft: { (action) in
            LoaderController.shared.goToSettings()
        }, completionHandlerRight: nil)
    }
    
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    func stopUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            self.locationManager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Remzi didUpdateLocations :\(locations.last)")
        
        guard let location = locations.last  else {
            return
        }
        
        if let currentLocation = currentLocation {
            if (location.coordinate.longitude == currentLocation.coordinate.longitude &&
                location.coordinate.latitude == currentLocation.coordinate.latitude) && !externalViewInitialize {
                return
            }
        }
        
        counter = counter + 1
        
        print("counter : \(counter)")
        
        self.currentLocation = location
        
        GeoFireData.shared.currentLocation = self.currentLocation
        
        delegate.didUpdateLocation()
        
    }
    
}
