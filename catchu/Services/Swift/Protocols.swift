//
//  Protocols.swift
//  catchu
//
//  Created by Erkut Baş on 9/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

protocol ImageHandlerProtocol: class {
    
    func returnImage(inputImage : UIImage)
    
}

protocol GroupInformationUpdateProtocol: class {
    
    func syncGroupInfoWithClient(inputGroup: Group, completion : @escaping (_ completionResult : Bool) -> Void)
    
}

protocol ShareDataProtocols: class {
    
    func dismisViewController()
    
}
