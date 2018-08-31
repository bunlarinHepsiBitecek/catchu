//
//  MapShareView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MapShareView: UIView {
    
    // MARK: outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var shareView: ShareView!
    
    @IBOutlet weak var shareViewButton: UIButton!
    @IBOutlet weak var shareViewBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
    }
    
    private func customization() {
        
        // MARK: MapView add into Container View and activate constraint
        self.containerView.addSubview(self.mapView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        let margins = self.safeAreaLayoutGuide
        let containerMargins = self.containerView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.mapView.leadingAnchor.constraint(equalTo: containerMargins.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: containerMargins.trailingAnchor),
            self.mapView.topAnchor.constraint(equalTo: containerMargins.topAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: containerMargins.bottomAnchor),

            self.containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.containerView.topAnchor.constraint(equalTo: margins.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: shareViewButton.topAnchor)
            ])
        
        
        // MARK: ShareView and activate constraint
        self.addSubview(self.shareView)
        self.shareView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.shareView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.shareView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.shareView.topAnchor.constraint(equalTo: shareViewButton.bottomAnchor),
            self.shareView.heightAnchor.constraint(equalToConstant: self.frame.height/2)
            ])
        
        self.shareView.masterMapShareView = self
    }
    
    
    @IBAction func shareViewButtonClick(_ sender: UIButton) {
        self.showHideShareView()
    }
    
    func showHideShareView() {
        if (shareViewBottomConstraint.constant > 0) {
            shareViewBottomConstraint.constant = 0
            self.shareView.textField.resignFirstResponder()
        } else {
            shareViewBottomConstraint.constant = +self.frame.height/2
            self.shareView.textField.becomeFirstResponder()
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        
                        self.layoutIfNeeded()
                        
        }, completion: nil)
    }
    
}


extension MapShareView: UITextFieldDelegate {
    // to close keyboard when touches somewhere else but keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // to close keyboard when press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

