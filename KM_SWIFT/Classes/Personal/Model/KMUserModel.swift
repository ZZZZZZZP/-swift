//
//  KMUserModel.swift
//  swift预览
//
//  Created by Roc on 17/2/16.
//  Copyright © 2017年 zp. All rights reserved.
//

import Foundation

class KMUserModel: NSObject {
    //单例
    static let sharedInstance = KMUserModel()
    
    var UserCNName: String = ""
    var UserENName: String = ""
    var UserID: String = ""
    var UserToken: String = ""
    var UserType: Int = 0
    var UserLevel: Int = 0
    
    var Email: String = ""
    var Gender: Int = 0
    var IDNumber: String = ""
    var MemberId: String = ""
    var Mobile: String = ""
    var PhotoUrl: String = ""
    var Redirect: Int = 0
    var Token: String = ""
    var Url: String = ""
    
    //空实现
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}



