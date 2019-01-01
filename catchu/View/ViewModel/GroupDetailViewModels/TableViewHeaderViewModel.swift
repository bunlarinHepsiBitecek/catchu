//
//  TableViewHeaderViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

struct ImagePickerData {
    var image: UIImage?
    var pathExtension: String?
    var orientation: ImageOrientation?
    var imageAsData: Data?
}

class TableViewHeaderViewModel: BaseViewModel {
    
    var groupNameTextFieldFilled = CommonDynamic(false)
    var groupName = CommonDynamic(String())
    var groupImage = CommonDynamic(UIImage())
    
    var imagePickerData = CommonDynamic(ImagePickerData(image: nil, pathExtension: nil, orientation: nil, imageAsData: nil))
    
}
