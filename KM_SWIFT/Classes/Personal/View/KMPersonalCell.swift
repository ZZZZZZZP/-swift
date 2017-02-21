//
//  KMPersonalCell.swift
//  swift预览
//
//  Created by 张鹏 on 2017/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMPersonalCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        textLabel?.textColor = RGB(51, 51, 51)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imgW: CGFloat = 16
        let imgH: CGFloat = 16
        let imgX: CGFloat = 0
        let imgY: CGFloat = (contentView.height - imgH) * 0.5
        imageView?.frame = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
        
        textLabel?.x = imageView!.frame.maxX + 10
    }

}










