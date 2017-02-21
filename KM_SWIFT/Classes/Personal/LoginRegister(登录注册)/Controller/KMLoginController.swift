//
//  KMLoginController.swift
//  swift预览
//
//  Created by Roc on 17/2/14.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMLoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginView = KMLoginView(frame: view.bounds)
        loginView.delegate = self
        view.addSubview(loginView)
        
        setupNav()
    }
    
    //设置导航栏
    private func setupNav() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(img: #imageLiteral(resourceName: "back_icon"), target: self, action: #selector(back))
        
        let registerBtn = UIButton()
        registerBtn.setTitle("注册", for: .normal)
        registerBtn.setTitleColor(UIColor.white, for: .normal)
        registerBtn.sizeToFit()
        registerBtn.addTarget(self, action: #selector(registerClick), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: registerBtn)
    }
}

// MARK: - 点击事件
extension KMLoginController {
    
    @objc fileprivate func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func registerClick() {
        navigationController?.pushViewController(KMRegisterController(), animated: true)
    }
}

// MARK: - KMLoginViewDelegate实现代理方法
extension KMLoginController: KMLoginViewDelegate {
    
    func login(loginView: KMLoginView, mobile: String, password: String) {
        
        if mobile.characters.count != 11 {
            print("手机号不对")
            return
        }
        if password == "" {
            print("密码不能为空")
            return
        }
        
        KMNetworkManager.login(account: mobile, password: password) { (result, error) in
            
            kAppDelegate.loginStatus = KMLoginStatus.logging.rawValue
            if result == nil {
                print((error as! NSError).domain)
                return
            }
            
            let resultDict = result as? [String: Any]
            let status = resultDict?["Status"] as? Int
            
            if status != KMStatusCode.success.rawValue {
                let msg = resultDict?["Msg"] as? String
                print(msg ?? "服务器连接异常")
                return
            }
            //登录成功的处理
            guard let dataDict = resultDict?["Data"] as? [String: Any] else {
                return
            }
            
            kUserModel.setValuesForKeys(dataDict)
            kUserDefaults.set(mobile, forKey: kAccountKey)
            kUserDefaults.set(password, forKey: kPasswordKey)
            kUserDefaults.set(true, forKey: kIsLoginKey)
            kAppDelegate.loginStatus = KMLoginStatus.success.rawValue
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func forgetPassword(loginView: KMLoginView) {
        navigationController?.pushViewController(KMForgetPasswordController(), animated: true)
    }
}







