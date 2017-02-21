//
//  KMConst.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

let kScreenW =        UIScreen.main.bounds.width
let kScreenH =        UIScreen.main.bounds.height
let kFitWidthScale =  kScreenW / 375
let kFitHeightScale = kScreenH / 667

let kAppDelegate =    UIApplication.shared.delegate as! KMAppDelegate
let kRootVC =         UIApplication.shared.keyWindow!.rootViewController!
let kNetworkConfig =  KMNetworkConfig.sharedInstance  //网络配置
let kUserModel =      KMUserModel.sharedInstance  //用户模型单例
let kUserDefaults =   UserDefaults.standard

// MARK: - Key
let kAccountKey =     "kAccountKey"
let kPasswordKey =    "kPasswordKey"
let kIsLoginKey =     "kIsLoginKey"
//登录成功通知
let kLoginSuccessNotification = "kLoginSuccessNotification"

// MARK: - 颜色
let kBackgroudColor = UIColor("f4f3f8")
let kNavColor =       RGBA(59, 90, 239, 0.9)

// MARK: - 常用全局函数
func kRect(_ x: CGFloat,_ y: CGFloat,_ w: CGFloat,_ h: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: w, height: h)
}
func kSize(_ w: CGFloat,_ h: CGFloat) -> CGSize {
    return CGSize(width: w, height: h)
}
func kPoint(_ x: CGFloat,_ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}
func kInsets(_ top: CGFloat,_ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsetsMake(top, bottom, left, right)
}
func kFont(_ size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}








