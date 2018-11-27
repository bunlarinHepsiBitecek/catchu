//
//  CommonSticker.swift
//  catchu
//
//  Created by Erkut Baş on 11/23/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CommonSticker {
    
    public static var shared = CommonSticker()
    
    var stickerArray : Array<StickerCommonView>?
    
    func addStickerToArray(inputStickerView : StickerCommonView) {
        
        if CommonSticker.shared.stickerArray == nil {
            CommonSticker.shared.stickerArray = Array<StickerCommonView>()
        }
        
        CommonSticker.shared.stickerArray!.append(inputStickerView)
        
    }
    
    func emptyStickerArray() {
        
        CommonSticker.shared.stickerArray?.removeAll()
        
    }
    
}

