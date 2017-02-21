//
//  KMHistoryModel.swift
//  swift预览
//
//  Created by 张鹏 on 2017/2/18.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMHistoryModel: NSObject {

    var CreateDate: String = ""
    var ExamId: Int = 0
    var ExamTypeList: [[String: Any]]?
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    //空实现
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        super.setValuesForKeys(keyedValues)
        
        let timeString = (self.CreateDate as NSString).substring(to: 10)
        self.CreateDate = timeString
    }
}



