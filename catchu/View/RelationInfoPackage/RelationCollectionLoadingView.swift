//
//  RelationCollectionLoadingView.swift
//  catchu
//
//  Created by Erkut Baş on 12/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class RelationCollectionLoadingView: UIView {

    lazy var activityIndicator: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.hidesWhenStopped = true
        temp.startAnimating()
        return temp
    }()
    
    lazy var informationLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.ultraLight)
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        temp.text = LocalizedConstants.PostAttachmentInformation.gettingFriends
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeViewSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self) deinits")
        activityIndicator.stopAnimating()
    }
    
}

// MARK: - major functions
extension RelationCollectionLoadingView {
    
    func initializeViewSettings() {
        
        self.addSubview(activityIndicator)
        self.addSubview(informationLabel)
        
        let safe = self.safeAreaLayoutGuide
        let safeActivity = self.activityIndicator.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            activityIndicator.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            activityIndicator.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: self.frame.height),
            activityIndicator.widthAnchor.constraint(equalToConstant: self.frame.height),
            
            informationLabel.leadingAnchor.constraint(equalTo: safeActivity.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            informationLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            informationLabel.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            informationLabel.heightAnchor.constraint(equalToConstant: self.frame.height),
            
            ])
        
    }
    
    func setInformation(_ state : TableViewState) {
        
        switch state {
        case .empty:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.noneFollowers
        case .loading:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.gettingFriends
        default:
            return
        }
        
    }
    
}
