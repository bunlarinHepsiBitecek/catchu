//
//  FeedMapView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/23/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import MapKit

class FeedMapView: BaseView {
    
    let annotations: [PostAnnotation] = {
        let clown = PostAnnotation(title: "🤡",
                                    color: .brown,
                                    type: .good,
                                    coordinate: CLLocationCoordinate2DMake(54.98, 73.30))
        let developer = PostAnnotation(title: "👨🏻‍💻",
                                        color: .red,
                                        type: .good,
                                        coordinate: CLLocationCoordinate2DMake(54.98, 73.301))
        let developer2 = PostAnnotation(title: "👨🏻‍💻",
                                       color: .red,
                                       type: .good,
                                       coordinate: CLLocationCoordinate2DMake(54.98, 73.302))
        let shit = PostAnnotation(title: "💩",
                                   color: .gray,
                                   type: .bad,
                                   coordinate: CLLocationCoordinate2DMake(54.98, 73.305))
        let shit2 = PostAnnotation(title: "💩",
                                  color: .gray,
                                  type: .bad,
                                  coordinate: CLLocationCoordinate2DMake(54.98, 73.306))
        return [clown, developer, developer2, shit, shit2]
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.isRotateEnabled = true
        mapView.isOpaque = true
        return mapView
    }()
    
    private let zoom: CLLocationDegrees = Constants.Map.ZoomDegree
    
    var currentCoordinate: CLLocationCoordinate2D? {
        didSet {
//            if let currentCoordinate = currentCoordinate {
//                centerMap(currentCoordinate)
//            }
        }
    }
    var location: CLLocationCoordinate2D? {
        didSet {
//            if let location = location {
//                centerMap(location)
//                annotate(location)
//            }
        }
    }
    
    deinit {
//        LocationManager.shared.stopUpdateLocation()
    }
    
    override func setupView() {
        super.setupView()
        
        self.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            mapView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            mapView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            mapView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
            ])
        
//        LocationManager.shared.delegate = self
//        LocationManager.shared.startUpdateLocation()
        
        mapView.register(UserSpecialView.self,
                        forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        let coordinate = CLLocationCoordinate2DMake(54.98, 73.32)
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotations(annotations)
    }
    
    private func centerMap(_ coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func annotate(_ coordinate: CLLocationCoordinate2D) {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        mapView.addAnnotation(annotation)
        
    }
    
}

extension FeedMapView: LocationManagerDelegate {
    func didUpdateLocation() {
        print("didUpdateLocation starts")
        currentCoordinate = LocationManager.shared.currentLocation.coordinate
    }
}

extension FeedMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        let test = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        test.title = "Posts"
        test.subtitle = nil
        return test
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print("view.transform: \(view.transform)")
        
//        UIView.animate(withDuration: 0.5, animations: {
//            view.transform = CGAffineTransform(scaleX: 3, y: 3)
//        })
    }


    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
         print("view.transform: \(view.transform)")
//        UIView.animate(withDuration: 0.5, animations: {
//            view.transform = CGAffineTransform.identity
//        })
    }
    
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//    if annotation is MKUserLocation {
//    return nil
//    }
//
//        let reuseId = "CustomMarker"
//
//        var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//        if markerView == nil {
//            markerView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            markerView?.image = UserMarkerView.userImageForAnnotation()
//        }
//        else {
//            markerView!.annotation = annotation
//        }
//
//        return markerView
//    }
    
}

class UserSpecialView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            image = UserMarkerView.userImageForAnnotation()
            guard let annotation = newValue as? PostAnnotation else { return }
            clusteringIdentifier = annotation.type.rawValue
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        let imageView = UIImageView(frame: CGRect(x: -4, y: -4, width: 48, height: 59))
        imageView.image = UIImage(named: "icon-marker")
        self.insertSubview(imageView, at: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class UserMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? PostAnnotation else { return }
            clusteringIdentifier = annotation.type.rawValue
            markerTintColor = annotation.color
//            glyphText = annotation.title
//            glyphImage = UIImage(named: "earth")
            glyphImage = UserMarkerView.userImageForAnnotation()
//            image = UserMarkerView.userImageForAnnotation()
            canShowCallout = true
        }
    }
    
    class func userImageForAnnotation() -> UIImage {
        let param: CGFloat = 20
        let roundRect = CGRect(x: 0, y: 0, width: param, height: param)
        let size = CGSize(width: param, height: param)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        
        let myUserImgView = UIImageView(frame: roundRect)
        myUserImgView.image = UIImage(named: "cameraRequest.jpg")
        
        print("size: \(String(describing: myUserImgView.image?.size))")
        
        let layer: CALayer = myUserImgView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = myUserImgView.frame.size.width/2
        
//        layer.borderWidth = 2
//        layer.borderColor = UIColor.white.cgColor
        
        UIGraphicsBeginImageContextWithOptions(myUserImgView.bounds.size, myUserImgView.isOpaque, 0.0)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        roundedImage?.draw(in: roundRect)
        
        let resultImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        print("Result size: \(resultImg.size)")
        
        return resultImg.withRenderingMode(.alwaysTemplate)
    }
    
    func userImageForAnnotationOrginal() -> UIImage {
        
        let userPinImg : UIImage = UIImage(named: "earth")!
        UIGraphicsBeginImageContextWithOptions(userPinImg.size, false, 0.0);
        
        userPinImg.draw(in: CGRect(origin: .zero, size: userPinImg.size))
        
        let roundRect = CGRect(x: 2, y: 2, width: userPinImg.size.width-4, height: userPinImg.size.width-4)
        
        let myUserImgView = UIImageView(frame: roundRect)
        myUserImgView.image = UIImage(named: "cameraRequest.jpg")
        myUserImgView.backgroundColor = .clear
        
        let layer: CALayer = myUserImgView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = myUserImgView.frame.size.width/2
        
        UIGraphicsBeginImageContextWithOptions(myUserImgView.bounds.size, myUserImgView.isOpaque, 0.0)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        roundedImage?.draw(in: roundRect)
        
        let resultImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        print("Result size: \(resultImg.size)")
        
        return resultImg
    }
    
    func deneme() -> UIImage {
        
        let roundRect = CGRect(x: 2, y: 2, width: 40, height: 40)
        
        let myUserImgView = UIImageView(frame: roundRect)
        myUserImgView.image = UIImage(named: "cameraRequest.jpg")
        
        let circleMasked = myUserImgView.image?.circleMasked
        
        return circleMasked!
    }
    
}


final class PostAnnotation: NSObject, MKAnnotation {
    
    enum `Type`: String {
        case good, bad
    }
    
    let title: String?
    let color: UIColor
    let type: Type
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, color: UIColor, type: Type, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.color = color
        self.type = type
        self.coordinate = coordinate
    }
}


extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

