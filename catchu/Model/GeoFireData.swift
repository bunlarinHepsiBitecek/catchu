//
//  GeoFireData.swift
//  catchu
//
//  Created by Erkut Baş on 6/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MapKit

class GeoFireData {
    
    public static let shared = GeoFireData()
    
    private var _locationID : String
    private var _coordinateData : CLLocation
    private var _currentLocation : CLLocation
    
    private var _geofireDictionary : Dictionary<String, GeoFireData> = [:]
    
    init() {
        
        _locationID = Constants.CharacterConstants.SPACE
        _coordinateData = CLLocation()
        _currentLocation = CLLocation()
        
    }
    
    var locationID: String {
        get {
            return _locationID
        }
        set {
            _locationID = newValue
        }
    }
    
    var coordinateData: CLLocation {
        get {
            return _coordinateData
        }
        set {
            _coordinateData = newValue
        }
    }
    
    var currentLocation: CLLocation {
        get {
            return _currentLocation
        }
        set {
            _currentLocation = newValue
        }
    }
    
    var geofireDictionary: Dictionary<String, GeoFireData> {
        get {
            return _geofireDictionary
        }
        set {
            _geofireDictionary = newValue
        }
    }
    
    func appendElementToGeoFireDictionary(key : String, value : GeoFireData)  {
        
        _geofireDictionary[key] = value
        
    }
    
}
