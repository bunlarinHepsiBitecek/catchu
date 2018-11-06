//
//  Stickers.swift
//  catchu
//
//  Created by Erkut Baş on 10/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class Stickers {
    
    public static var shared = Stickers()
    
    var stickerArray : Array<CustomSticker2>?
    
    func addStickerToArray(inputStickerView : CustomSticker2) {
        
        if Stickers.shared.stickerArray == nil {
            Stickers.shared.stickerArray = Array<CustomSticker2>()
        }
        
        Stickers.shared.stickerArray!.append(inputStickerView)
        
    }
    
    func emptyStickerArray() {
        
        Stickers.shared.stickerArray?.removeAll()
        
    }
    
}
