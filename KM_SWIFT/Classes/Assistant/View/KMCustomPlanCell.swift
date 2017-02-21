//
//  KMCustomPlanCell.swift
//  swift预览
//
//  Created by 张鹏 on 2017/2/19.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

protocol KMCustomPlanCellDelegate {
    func selectedModel(cell: KMCustomPlanCell?, model: KMCustomPlanModel)
}

class KMCustomPlanCell: UICollectionViewCell {
    
    fileprivate lazy var dataDict = ["0":"small_02",
                                     "1":"small_03",
                                     "2":"small_04",
                                     "3":"small_01",
                                     "101":"small_05",
                                     "102":"small_06",
                                     "103":"small_07",
                                     "104":"small_08",]
    
    var delegate: KMCustomPlanCellDelegate?
    var model: KMCustomPlanModel? {
        didSet {
            guard let model = model else {
                return
            }
            weekLabel.text = model.dateMode?.weekDay
            dayBtn.setTitle(String(format: "%02d", model.dateMode!.day), for: .normal)
            dayBtn.isSelected = model.isSelected
            
            //展示配置计划
            showAllPlan()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var weekLabel = UILabel()
    fileprivate lazy var dayBtn = UIButton()
    fileprivate lazy var planView = UIView()
}

// MARK: - UI界面搭建
extension KMCustomPlanCell {
    
    fileprivate func setupUI() {
        
        contentView.addSubview(weekLabel)
        weekLabel.font = kFont(14)
        weekLabel.textColor = RGB(182, 182, 182)
        weekLabel.textAlignment = .center
        
        contentView.addSubview(dayBtn)
        dayBtn.setTitleColor(RGB(68, 68, 68), for: .normal)
        dayBtn.setTitleColor(UIColor("4b75f3"), for: .selected)
        dayBtn.addTarget(self, action: #selector(dayBtnClick), for: .touchUpInside)
        
        contentView.addSubview(planView)
    }
    
    //展示配置计划
    fileprivate func showAllPlan() {
        
        for view in planView.subviews {
            view.removeFromSuperview()
        }
        //医生计划
        for (i, type) in model!.doctorPlans.enumerated() {
            
            let img = UIImageView()
            img.image = UIImage(named: dataDict[String(type)]!)
            
            let imgW: CGFloat = 10 * kFitWidthScale
            let imgH: CGFloat = 12 * kFitWidthScale
            let space = (contentView.width - CGFloat(model!.doctorPlans.count) * imgW) * 0.5
            let imgX: CGFloat = space + CGFloat(i) * imgW
            let imgY: CGFloat = 0
            img.frame = kRect(imgX, imgY, imgW, imgH)
            
            planView.addSubview(img)
        }
        //用户计划
        for (i, type) in model!.userPlans.enumerated() {
            
            let img = UIImageView()
            img.image = UIImage(named: dataDict[String(type)]!)
            
            let imgW: CGFloat = 10 * kFitWidthScale
            let imgH: CGFloat = 12 * kFitWidthScale
            let space = (contentView.width - CGFloat(model!.userPlans.count) * imgW) * 0.5
            let imgX: CGFloat = space + CGFloat(i) * imgW
            let imgY: CGFloat = 17 * kFitWidthScale
            img.frame = kRect(imgX, imgY, imgW, imgH)
            
            planView.addSubview(img)
        }
    }
    
    //布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        weekLabel.frame = kRect(0, 0, contentView.width, 30 * kFitHeightScale)
        
        let dayWH: CGFloat = 35 * kFitWidthScale
        let dayX : CGFloat = (contentView.width - dayWH) * 0.5
        let dayY : CGFloat = weekLabel.bottom
        dayBtn.frame = kRect(dayX, dayY, dayWH, dayWH)
        
        let planY = dayBtn.bottom
        let planW = contentView.width
        let planH = contentView.height - planY
        planView.frame = kRect(0, planY, planW, planH)
    }
}

// MARK: - 按钮点击事件
extension KMCustomPlanCell {
    
    @objc fileprivate func dayBtnClick() {
        delegate?.selectedModel(cell: self, model: model!)
    }
}







