//
//  KMSettingCell.swift
//  swift预览
//
//  Created by Roc on 17/2/17.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMSettingCell: UITableViewCell {

    var isVersionCell: Bool {
        
        set{
            versionLabel.isHidden = !newValue
            if newValue {
                accessoryType = .none
            }
            else {
                accessoryType = .disclosureIndicator
            }
        }
        get {
            return self.isVersionCell
        }
    }
    
    fileprivate lazy var versionLabel: UILabel = {
        
        let version = UILabel()
        let app_Version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        version.text = "当前版本：V" + app_Version
        version.textAlignment = .center
        version.textColor = RGB(153, 153, 153)
        
        return version
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        textLabel?.textColor = RGB(51, 51, 51)
        addSubview(versionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - UI界面布局
extension KMSettingCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.x += 10
        
        let versW: CGFloat = 120
        let versH: CGFloat = 30
        let versX: CGFloat = contentView.width - versW - 15
        let versY: CGFloat = (contentView.height - versH) * 0.5
        versionLabel.frame = kRect(versX, versY, versW, versH)
    }
}









