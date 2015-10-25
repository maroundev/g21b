//
//  IBDesignable.swift
//  g21b
//
//  Created by Maroun Abi Ramia on 9/7/15.
//  Copyright (c) 2015 Maroun Abi Ramia. All rights reserved.
//

import UIKit

@IBDesignable class IBDesignable: UIView {
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.frame.height/2
        }
    }
    
    @IBInspectable var op: Bool!{
        didSet{
            layer.opaque = op
        }
    }
    
    @IBInspectable var _shadowColor: CGColor! {
        didSet {
            layer.shadowColor = _shadowColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
//    @IBInspectable var shadowOffset: CGSize! {
//        didSet {
//            layer.shadowOffset = shadowOffset
//        }
//    }

    @IBInspectable var shadowPath: CGPath! {
        didSet {
            layer.shadowPath = shadowPath
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor! {
        didSet {
            layer.shadowColor = shadowColor.CGColor
        }
    }
}
