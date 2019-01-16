//
//  CustomMapView.swift
//  catchu
//
//  Created by Erkut Baş on 10/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MapKit

class CustomMapView: UIView {

    private var mapView : MKMapView!
    private var mapViewBottomCornerRadiuesDone : Bool = false
    
    var zoom: CLLocationDegrees = Constants.Map.ZoomDegree_0_0025
    
    var coordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = coordinate {
                centerMap(coordinate: coordinate)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        customizeView()
        
    }
    
}

// MARK: - major functions
extension CustomMapView {
    
    func setupSettings() {
    
        addMapView()
        customizeView()
        setMapViewSettings()
        setLocationManangerSettings()
        
    }
    
    func addMapView() {
        
        mapView = MKMapView()
        
        self.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: safe.topAnchor)
            
            ])
        
    }
    
    func customizeView() {
        
        print("customMapView starts ")
        print("self.bound : \(self.bounds)")
        
        self.layer.cornerRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
//        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.8
        
        if mapView.frame.height > 0 {
            if !mapViewBottomCornerRadiuesDone {
                let rectShape = CAShapeLayer()
                rectShape.bounds = mapView.frame
                rectShape.position = mapView.center
                rectShape.path = UIBezierPath(roundedRect: mapView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 25, height: 25)).cgPath
                
                mapView.layer.mask = rectShape
                
                mapViewBottomCornerRadiuesDone = true
            }
        }
    }
    
    func setMapViewSettings() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.isRotateEnabled = true
        mapView.isOpaque = true
        
    }
    
    func setLocationManangerSettings() {
        
        LocationManager.shared.delegate = self
        LocationManager.shared.startUpdateLocation()
        
    }
    
    func centerMap(coordinate : CLLocationCoordinate2D) {
        
        print("centerMap starts")
        print("coordinate : \(coordinate)")
        
        let span = MKCoordinateSpanMake(zoom, zoom)
//        let span = MKCoordinateSpanMake(coordinate.latitude, coordinate.longitude)
        let region = MKCoordinateRegionMake(coordinate, span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
}

// MARK: - MKMapViewDelegate
extension CustomMapView : MKMapViewDelegate {
    
}

// MARK: - LocationManagerDelegate
extension CustomMapView : LocationManagerDelegate {
    func didUpdateLocation() {
        print("didUpdateLocation starts in customMapView")
        
//        self.coordinate = LocationManager.shared.currentLocation.coordinate
        mapView.centerCoordinate = LocationManager.shared.currentLocation.coordinate
        centerMap(coordinate: mapView.centerCoordinate)
        
        LocationManager.shared.stopUpdateLocation()
        
    }
    
    
}
