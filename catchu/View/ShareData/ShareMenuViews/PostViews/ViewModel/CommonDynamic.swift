//
//  CommonDynamic.swift
//  catchu
//
//  Created by Erkut Baş on 12/1/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class CommonDynamic<T> {
    
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v : T) {
        value = v
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener : Listener?) {
        self.listener = listener
        listener?(value)
    }

    func unbind()  {
        self.listener = nil
    }
    
}
