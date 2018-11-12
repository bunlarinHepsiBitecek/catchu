//
//  Dynamic.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    func unbind() {
        listener = nil
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
}
