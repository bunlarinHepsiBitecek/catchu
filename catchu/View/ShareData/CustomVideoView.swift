//
//  CustomVideoView.swift
//  catchu
//
//  Created by Erkut Baş on 9/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomVideoView: UIView {

    let customVideo = CustomVideo()
    
    lazy var mainView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var recordButton: UIView = {
        
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        temp.layer.borderWidth = 5
        temp.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = 35
        
        return temp
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupViews()
        initiateVideoProcess()
        setGestureToRecordButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.addSubview(mainView)
        self.mainView.addSubview(recordButton)
        
        let safe = self.safeAreaLayoutGuide
        let safeMainview = self.mainView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            mainView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            recordButton.bottomAnchor.constraint(equalTo: safeMainview.bottomAnchor, constant: -30),
            recordButton.centerXAnchor.constraint(equalTo: safeMainview.centerXAnchor),
            recordButton.heightAnchor.constraint(equalToConstant: 70),
            recordButton.widthAnchor.constraint(equalToConstant: 70),
        
            ])
        
    }
    
    func initiateVideoProcess() {
        
        func configureCustomVideo() {
            customVideo.prepare { (error) in
                if let error = error {
                    print(error)
                }
                
                try? self.customVideo.displayPreviewForVideo(on: self.mainView)
            }
        }
        
        configureCustomVideo()
        
    }
    
}

extension CustomVideoView : UIGestureRecognizerDelegate {
    
    func setGestureToRecordButton() {
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(CustomVideoView.startRecordAnimation(_:)))
        longGesture.delegate = self
        recordButton.addGestureRecognizer(longGesture)
        
    }
    
    @objc func startRecordAnimation(_ sender : UILongPressGestureRecognizer)  {
        
        UIView.transition(with: recordButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            self.recordButton.frame.size = CGSize(width: 90, height: 90)
            self.recordButton.layer.cornerRadius = 45
            self.recordButton.layer.borderWidth = 20
            self.recordButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            
        })
        
        
    }
    
}
