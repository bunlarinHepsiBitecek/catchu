//
//  ShareDataView.swift
//  catchu
//
//  Created by Erkut Baş on 9/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MapKit

class ShareDataView: UIView {

    @IBOutlet var mapKit: MKMapView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var topBarView: UIView!
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet var typeSliderContainerView: UIViewDesign!
    @IBOutlet var majorFunctionsContainerView: UIView!
    
    @IBOutlet weak var shareTypeSliderView: UIView!
    
    weak var delegate : ShareDataProtocols!
    
    var zoom: CLLocationDegrees = Constants.Map.ZoomDegree
    var coordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = coordinate {
                centerMap(coordinate)
            }
        }
    }
    
    func initialize() {
        
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        setupTopBarSettings()
        setupMapContainerSettings()
        setupMapKitSettings()
        setupBottomContainerViewSettings()
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        // if you dont stop location service, even if you remove view, because of no changes on location, update location service does not work
        LocationManager.shared.stopUpdateLocation()
        LocationManager.shared.externalViewInitialize = false
        
        delegate.dismisViewController()
        
    }
}


// MARK: - Major Functions
extension ShareDataView {
    
    func setupBottomContainerViewSettings() {
        
        bottomContainerView.layer.cornerRadius = 7
        bottomContainerView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        bottomContainerView.clipsToBounds = true
        
    }
    
    func setupTopBarSettings() {
        
//        topBarView.layer.cornerRadius = 7

        let gradient = CAGradientLayer()
        gradient.frame = topBarView.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        topBarView.layer.insertSublayer(gradient, at: 0)
        topBarView.backgroundColor = UIColor.clear
        
        setupTopBarObjectSettings()
        
    }
    
    func setupMapContainerSettings() {
        
        mapContainerView.layer.cornerRadius = 7
        
    }
    
    func setupTopBarObjectSettings() {
        
        cancelButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.cancel, for: .normal)
        
    }
    
}

extension ShareDataView : MKMapViewDelegate {
    
    private func setupMapKitSettings() {
        
        mapKit.delegate = self
        mapKit.showsUserLocation = true
        mapKit.showsCompass = true
        mapKit.isRotateEnabled = true
        //mapKit.isOpaque = true
        
        LocationManager.shared.delegete = self
        LocationManager.shared.externalViewInitialize = true
        LocationManager.shared.startUpdateLocation()
        
    }
    
    private func centerMap(_ coordinate: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpanMake(zoom, zoom)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapKit.setRegion(region, animated: true)
        
    }
    
    
}

extension ShareDataView: LocationManagerDelegate {
    func didUpdateLocation() {
        
        print("Yarro baskan buraya :D")
        
        mapKit.centerCoordinate = LocationManager.shared.currentLocation.coordinate
        
//        coordinate = LocationManager.shared.currentLocation.coordinate
        centerMap(mapKit.centerCoordinate)
        
    }
    
    
}
