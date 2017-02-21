//
//  KMPlanView.swift
//  swift预览
//
//  Created by 张鹏 on 2017/2/19.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMPlanView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var exeType: Int = -1
    // MARK: - 懒加载控件
    lazy var iconBtn = UIButton()
    lazy var titleLabel = UILabel()
}

// MARK: - UI界面搭建
extension KMPlanView {
    
    fileprivate func setupUI() {
        
        addSubview(iconBtn)
        iconBtn.adjustsImageWhenHighlighted = false
        
        addSubview(titleLabel)
        titleLabel.font = kFont(14)
        titleLabel.textColor = RGB(102, 102, 102)
        titleLabel.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconWH = 58 * kFitWidthScale
        let iconX  = (width - iconWH) * 0.5
        let iconY  = 20 * kFitHeightScale
        iconBtn.frame = kRect(iconX, iconY, iconWH, iconWH)
        
        let labelY = iconBtn.bottom
        let labelH = 30 * kFitHeightScale
        titleLabel.frame = kRect(0, labelY, width, labelH)
        
    }
    
}









