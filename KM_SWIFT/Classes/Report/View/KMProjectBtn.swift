//
//  KMProjectBtn.swift
//  swift预览
//
//  Created by 张鹏 on 2017/2/19.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMProjectBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(RGB(102, 102, 102), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 12 * kFitWidthScale)
        isEnabled = false
        adjustsImageWhenDisabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = kRect(0, 0, width, width)
        titleLabel?.frame = kRect(0, width + 10, width, 11)
    }

}







