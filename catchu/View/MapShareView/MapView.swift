//
//  MapView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIView {
    
    // MARK: outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: variable
    var zoom: CLLocationDegrees = Constants.Map.ZoomDegree
    var coordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = coordinate {
                centerMap(coordinate)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
    }
    
    private func customization() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.isRotateEnabled = true
        mapView.isOpaque = true
        
        LocationManager.shared.delegete = self
        LocationManager.shared.startUpdateLocation()
    }
    
    private func centerMap(_ coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(zoom, zoom)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func annotate(_ coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
}

extension MapView: LocationManagerDelegate {
    func didUpdateLocation() {
        self.coordinate = LocationManager.shared.currentLocation.coordinate
    }
}

extension MapView: MKMapViewDelegate {
    
}
