//
//  LoadingCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/20/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class LoadingCell: BaseTableCell {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.backgroundView = activityIndicatorView
    }
    
    func configure() {
        activityIndicatorView.startAnimating()
    }
}

class CollectionFooterActivityView: BaseCollectionReusableView {
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        
        return activityView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            activityIndicatorView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            activityIndicatorView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            activityIndicatorView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
            ])
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
