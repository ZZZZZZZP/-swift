//
//  KMRegisterController.swift
//  swift预览
//
//  Created by Roc on 17/2/16.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMRegisterController: UIViewController {

    lazy var registerView: KMRegistView = KMRegistView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "注册"
        
        registerView.frame = view.bounds
        registerView.delegate = self
        view.addSubview(registerView)
        
        setupNav()
    }
}

// MARK: - UI界面布局
extension KMRegisterController {
    
    fileprivate func setupNav() {
        
        let navView = UIView()
        navView.frame = kRect(0, 0, kScreenW, 64)
        navView.backgroundColor = kNavColor
        view.addSubview(navView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(img: #imageLiteral(resourceName: "back_icon"), target: self, action: #selector(back))
    }
}

// MARK: - 点击事件
extension KMRegisterController {
    
    @objc fileprivate func back() {
        navigationController!.popViewController(animated: true)
    }
}

// MARK: - KMRegistViewDelegate代理方法实现
extension KMRegisterController: KMRegistViewDelegate {
    
    func getCode(registView: KMRegistView, mobile: String) {
        if mobile.characters.count != 11 {
            print("手机号不对")
            return
        }
        let url = "http://apirtu.kmwlyy.com/users/sendSmsCode"
        let params = ["Mobile":mobile, "MsgType":"1", "OrgID":"kmsd"]
        
        KMNetworkManager.request(url: url, method: .POST, params: params) { (result, error) in
            if result == nil {
                print("网络连接异常")
                return
            }
            let resultDict = result as? [String: Any]
            let status = resultDict?["Status"] as? Int
            
            if status != 0 {
                let msg = resultDict?["Msg"] as! String
                print(msg)
                return
            }
            //获取验证码成功
            print("发送成功")
            registView.getCodeSuccess?()
        }
    }
    
    //注册账号
    func regist(registView: KMRegistView, mobile: String, code: String, password: String) {
        let url = "http://apirtu.kmwlyy.com/users/userRegister"
        let params = ["Mobile":mobile, "Password":password, "MsgType":"1", "MsgVerifyCode":code, "UserType":"1", "Terminal":"2", "OrgID":"kmsd", "AppType":"IOS"]
        
        KMNetworkManager.request(url: url, method: .POST, params: params) { (result, error) in
            if result == nil {
                print("网络连接异常")
                return
            }
            let resultDict = result as? [String: Any]
            let status = resultDict?["Status"] as? Int
            
            if status != 0 {
                let msg = resultDict?["Msg"] as! String
                print(msg)
                return
            }
            //注册成功
            print("注册成功")
            self.navigationController!.popViewController(animated: true)
        }
    }
}





