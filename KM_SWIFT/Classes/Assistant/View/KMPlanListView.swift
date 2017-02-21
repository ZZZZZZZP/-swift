//
//  KMPlanListView.swift
//  swift预览
//
//  Created by 张鹏 on 2017/2/19.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMPlanListView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 懒加载控件
    lazy var planLabel = UILabel()
    lazy var planView = UIView()
}

// MARK: - UI界面搭建
extension KMPlanListView {
    
    fileprivate func setupUI() {
        
        addSubview(planView)
        addSubview(planLabel)
        planLabel.font = kFont(14)
        planLabel.textAlignment = .center
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        planLabel.frame = kRect(0, 0, width, 20)
        
        let planY = planLabel.bottom
        let planH = height - planY
        planView.frame = kRect(0, planY, width, planH)
    }
}









