//
//  KMForgetPasswordController.swift
//  swift预览
//
//  Created by Roc on 17/2/16.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMForgetPasswordController: UIViewController {

    var forgetPasswordView: KMForgetPasswordView = KMForgetPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "忘记密码"
        
        forgetPasswordView.frame = view.bounds
        forgetPasswordView.delegate = self
        view.addSubview(forgetPasswordView)
        
        setupNav()
    }

}

// MARK: - UI界面布局
extension KMForgetPasswordController {
    
    fileprivate func setupNav() {
        
        let navView = UIView()
        navView.frame = kRect(0, 0, kScreenW, 64)
        navView.backgroundColor = kNavColor
        view.addSubview(navView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(img: #imageLiteral(resourceName: "back_icon"), target: self, action: #selector(back))
    }
}

// MARK: - 点击事件
extension KMForgetPasswordController {
    
    @objc fileprivate func back() {
        navigationController!.popViewController(animated: true)
    }
}

// MARK: - KMForgetPasswordViewDelegate代理方法实现
extension KMForgetPasswordController: KMForgetPasswordViewDelegate {
    
    func getCode(forgetPasswordView: KMForgetPasswordView, mobile: String) {
        if mobile.characters.count != 11 {
            print("手机号不对")
            return
        }
        let url = "http://apirtu.kmwlyy.com/users/sendSmsCode"
        let params = ["Mobile":mobile, "MsgType":"2", "OrgID":"kmsd"]
        
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
            forgetPasswordView.getCodeSuccess?()
        }
    }
    
    //重置密码
    func resetPassword(forgetPasswordView: KMForgetPasswordView, mobile: String, code: String, password: String) {
        
        let url = "http://apirtu.kmwlyy.com/users/userFindPwd"
        let params = ["Mobile":mobile, "Password":password, "MsgType":"2", "MsgVerifyCode":code]
        
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
            //重置密码成功
            print("重置密码成功")
            self.navigationController!.popViewController(animated: true)
        }
    }
}








