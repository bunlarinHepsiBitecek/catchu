//
//  LoaderTransition.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

public struct LoaderTransition {
    
    /// Curve of animation
    ///
    /// - linear: linear
    /// - easeIn: ease in
    /// - easeOut: ease out
    /// - easeInOut: ease in - ease out
    public enum Curve {
        case linear
        case easeIn
        case easeOut
        case easeInOut
        case `default`
        
        /// Return the media timing function associated with curve
        internal var function: CAMediaTimingFunction {
            let name: String!
            switch self {
            case .linear:
                name = kCAMediaTimingFunctionLinear
            case .easeIn:
                name = kCAMediaTimingFunctionEaseIn
            case .easeOut:
                name = kCAMediaTimingFunctionEaseOut
            case .easeInOut:
                name = kCAMediaTimingFunctionEaseInEaseOut
            case .default:
                name = kCAMediaTimingFunctionDefault
            }
            return CAMediaTimingFunction(name: name)
        }
    }
    
    /// Direction of the animation
    ///
    /// - fade: fade to new controller
    /// - toTop: slide from bottom to top
    /// - toBottom: slide from top to bottom
    /// - toLeft: pop to left
    /// - toRight: push to right
    public enum Direction {
        case fade
        case toTop
        case toBottom
        case toLeft
        case toRight
        
        /// Return the associated transition
        ///
        /// - Returns: transition
        internal func transition() -> CATransition {
            let transition = CATransition()
            transition.type = kCATransitionPush
            switch self {
            case .fade:
                transition.type = kCATransitionFade
                transition.subtype = nil
            case .toLeft:
                transition.subtype = kCATransitionFromLeft
            case .toRight:
                transition.subtype = kCATransitionFromRight
            case .toTop:
                transition.subtype = kCATransitionFromTop
            case .toBottom:
                transition.subtype = kCATransitionFromBottom
            }
            return transition
        }
    }
    
    /// Duration of the animation (default is 0.20s)
    public var duration: TimeInterval = 0.20
    
    /// Direction of the transition (default is `toRight`)
    public var direction: LoaderTransition.Direction = .toRight
    
    /// Style of the transition (default is `linear`)
    public var style: LoaderTransition.Curve = .linear
    
    /// Animation key
    public var forKey: String = kCATransition
    
    /// Initialize a new options object with given direction and curve
    ///
    /// - Parameters:
    ///   - direction: direction
    ///   - style: style
    public init(direction: LoaderTransition.Direction = .toRight, style: LoaderTransition.Curve = .linear, duration: CFTimeInterval = 0.5) {
        self.direction = direction
        self.style = style
        self.duration = duration
    }
    
    public init() { }
    
    /// Return the animation to perform for given options object
    internal var animation: CATransition {
        let transition = self.direction.transition()
        transition.duration = self.duration
        transition.timingFunction = self.style.function
        return transition
    }
}
