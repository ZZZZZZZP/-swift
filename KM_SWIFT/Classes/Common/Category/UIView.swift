//
//  UIView.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

extension UIView {
    
    var x: CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.y
        }
    }
    
    var width: CGFloat {
        set {
            frame.size.width = newValue
        }
        get {
            return frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            frame.size.height = newValue
        }
        get {
            return frame.size.height
        }
    }
    
    var centerX: CGFloat {
        set {
            center.x = newValue
        }
        get {
            return center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            center.y = newValue
        }
        get {
            return center.y
        }
    }
    
    var size: CGSize {
        set {
            frame.size = newValue
        }
        get {
            return frame.size
        }
    }
    
    var top: CGFloat {
        set {
            frame.origin.y = newValue
        }
        get {
            return frame.origin.y
        }
    }
    
    var bottom: CGFloat {
        set {
            frame.origin.y = newValue - frame.size.height
        }
        get {
            return frame.origin.y + frame.size.height
        }
    }
    
    var left: CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.x
        }
    }
    
    var right: CGFloat {
        set {
            frame.origin.x = newValue - frame.size.width
        }
        get {
            return frame.origin.x + frame.size.width
        }
    }
}



