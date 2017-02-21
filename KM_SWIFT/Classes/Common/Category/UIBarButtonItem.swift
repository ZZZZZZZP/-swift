//
//  UIBarButtonItem.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(img: UIImage, hImg: UIImage? = nil, size: CGSize = CGSize.zero, target: Any? = nil, action: Selector? = nil) {
        
        let btn = UIButton()
        btn.setImage(img, for: .normal)
        
        if let hImg = hImg {
            btn.setImage(hImg, for: .highlighted)
        }
        
        if size == CGSize.zero {
            btn.sizeToFit()
        }
        else {
            btn.size = size
        }
        
        if let target = target, let action = action {
            btn.addTarget(target, action: action, for: .touchUpInside)
        }
        
        self.init(customView: btn)
    }
}
