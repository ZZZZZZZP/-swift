//
//  UIColor.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var random: UIColor {
        return RGB(CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256)))
    }
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
    
    convenience init(_ hexString: String) {
        
        var cString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        
        if cString.hasPrefix("#") {
            cString = cString.substring(from: 1) as NSString
        }
        
        if cString.length != 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        let rString = cString.substring(to: 2)
        let gString = (cString.substring(from: 2) as NSString).substring(to: 2)
        let bString = (cString.substring(from: 4) as NSString).substring(to: 2)
        
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
    }
    
    //十六进制颜色
    class func colorWithHexString(hex: String) -> UIColor {
        
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        
        if cString.hasPrefix("#") {
            cString = cString.substring(from: 1) as NSString
        }
        
        if cString.length != 6 {
            return UIColor.gray
        }
        
        let rString = cString.substring(to: 2)
        let gString = (cString.substring(from: 2) as NSString).substring(to: 2)
        let bString = (cString.substring(from: 4) as NSString).substring(to: 2)
        
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return RGB(CGFloat(r), CGFloat(g), CGFloat(b))
    }
}

func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return RGBA(r, g, b, 1)
}


