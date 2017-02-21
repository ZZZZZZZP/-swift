//
//  KMHistoryCell.swift
//  swift预览
//
//  Created by 张鹏 on 2017/2/17.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMHistoryCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    lazy var iconDict = {
        return ["常规":"常规检查",
                "血压":"血压",
                "心电":"心电",
                "尿检":"尿检",
                "多参":"多参检测",
                "血糖":"血糖",
                "血氧":"血氧"]
    }()
    
    var model: KMHistoryModel? {
        didSet {
            guard let model = model else {
                return
            }
            
            addProjectButton()
            
            let dateModel = KMDateModel(timeString: model.CreateDate)
            dayBtn.setTitle(String(format: "%02d", dateModel.day), for: .normal)
        }
    }
    
    fileprivate lazy var dayBtn = UIButton()
    fileprivate lazy var projView = UIView()
    
}

// MARK: - UI界面搭建
extension KMHistoryCell {
    
    fileprivate func setupUI() {
        
        contentView.addSubview(dayBtn)
        dayBtn.setBackgroundImage(#imageLiteral(resourceName: "context"), for: .normal)
        dayBtn.setTitleColor(UIColor.white, for: .normal)
        
        contentView.addSubview(projView)
    }
    
    fileprivate func addProjectButton() {
        
        for view in projView.subviews {
            view.removeFromSuperview()
        }
        
        var projBtn: UIButton!
        let btnW: CGFloat = 28 * kFitWidthScale
        let btnH: CGFloat = 50
        for i in 0..<model!.ExamTypeList!.count {
            let btnX = CGFloat(i) * (btnW + 11 * kFitWidthScale)
            projBtn = KMProjectBtn()
            projBtn.frame = kRect(btnX, 0, btnW, btnH)
            projView.addSubview(projBtn)
            //赋值
            let projName = (model?.ExamTypeList?[i]["ReportItemName"] as? NSString)?.substring(to: 2)
            projBtn.setTitle(projName, for: .normal)
            projBtn.setImage(UIImage(named: iconDict[projName!]!), for: .normal)
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let dayW: CGFloat = 35 * kFitWidthScale
        let dayH: CGFloat = 35 * kFitWidthScale
        let dayX: CGFloat = 15
        let dayY: CGFloat = (contentView.height - dayH) * 0.5
        dayBtn.frame = kRect(dayX, dayY, dayW, dayH)
        
        let projX: CGFloat = dayBtn.right + 15 * kFitWidthScale
        let projW: CGFloat = contentView.width - projX
        let projH: CGFloat = 50
        let projY: CGFloat = (contentView.height - projH) * 0.5
        projView.frame = kRect(projX, projY, projW, projH)
    }
}










