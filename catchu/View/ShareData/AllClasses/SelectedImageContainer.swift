//
//  SelectedImageContainer.swift
//  catchu
//
//  Created by Erkut Baş on 9/7/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SelectedImageContainer: UIView {

    // it's used for selected images from collectionView
    let selectedImageContainerView : UIView = {
        
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.alpha = 0
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    let selectedImageView : UIImageView = {
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    

}
