//
//  KMAppDelegate.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

private let kPersonalWidth: CGFloat = kScreenW * 4 / 5
private let normalAlpha: CGFloat = 0.2

@UIApplicationMain
class KMAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    dynamic var loginStatus = 0
    
    //个人中心
    lazy var personalVC: KMPersonalController = {
        let vc = KMPersonalController()
        vc.view.frame = CGRect(x: -kPersonalWidth * 0.5, y: 0, width: kPersonalWidth, height: kScreenH)
        return vc
    }()
    
    //遮罩
    lazy var markView: UIView = {[weak self] in
        
        let markView = UIView()
        markView.frame = kRootVC.view.bounds
        markView.backgroundColor = UIColor(white: 0, alpha: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePersonal))
        markView.addGestureRecognizer(tap)
        
        return markView
    }()
    
    var maskViewAlpha: CGFloat = 0
    
    //拖拽手势
    lazy var pan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        return pan
    }()
    
    // MARK: - APP入口
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = KMTabBarController()
        window?.addSubview(personalVC.view)
        window?.makeKeyAndVisible()
        
        loginStatus = KMLoginStatus.notLogin.rawValue
        autoLogin()  //检查自动登录
        addPersonalPanGesture()  //添加侧滑手势
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
}

//自动登录
extension KMAppDelegate {
    
    fileprivate func autoLogin() {
        
        let isLogin = kUserDefaults.bool(forKey: kIsLoginKey)
        if !isLogin {
            return
        }
        
        let account = kUserDefaults.string(forKey: kAccountKey)
        let password = kUserDefaults.string(forKey: kPasswordKey)
        
        KMNetworkManager.login(account: account!, password: password!) { (result, error) in
            
            self.loginStatus = KMLoginStatus.logging.rawValue
            if result == nil {
                print((error as! NSError).domain)
                self.loginStatus = KMLoginStatus.failure.rawValue
                return
            }
            
            let resultDict = result as? [String: Any]
            let status = resultDict?["Status"] as? Int
            
            if status != KMStatusCode.success.rawValue {
                let msg = resultDict?["Msg"] as? String
                print(msg ?? "服务器连接异常")
                self.loginStatus = KMLoginStatus.failure.rawValue
                return
            }
            //登录成功的处理
            guard let dataDict = resultDict?["Data"] as? [String: Any] else {
                return
            }
            kUserModel.setValuesForKeys(dataDict)
            self.loginStatus = KMLoginStatus.success.rawValue
        }
    }
}

// MARK: - 个人中心侧滑
extension KMAppDelegate {
    
    // 展示个人中心
    func showPersonal() {
        
        addMaskView()
        let leftView = window?.subviews.first
        UIView.animate(withDuration: 0.25) { 
            kRootVC.view.x = kPersonalWidth - 1
            leftView?.x = 0
            self.markView.backgroundColor = UIColor(white: 0, alpha: normalAlpha)
        }
    }
    
    // 隐藏个人中心
    func hidePersonal() {
        
        let leftView = window?.subviews.first
        UIView.animate(withDuration: 0.25, animations: {
            kRootVC.view.x = 0
            leftView?.x = -kPersonalWidth * 0.5
            self.markView.backgroundColor = UIColor(white: 0, alpha: 0)
        }) { (finished) in
            self.markView.removeFromSuperview()
        }
    }
    
    //添加手势
    fileprivate func addPersonalPanGesture() {
        kRootVC.view.addGestureRecognizer(pan)
    }
    
    //拖拽手势实现
    @objc fileprivate func pan(pan: UIPanGestureRecognizer) {
        
        let offset = pan.translation(in: pan.view)
        pan.view?.x += offset.x
        maskViewAlpha = pan.view!.x / kPersonalWidth * normalAlpha
        markView.backgroundColor = UIColor(white: 0, alpha: maskViewAlpha)
        
        if pan.view!.x < CGFloat(0) {
            pan.view?.x = 0
            markView.removeFromSuperview()
            return
        }
        if pan.state == .began {
            if markView.superview == nil {
                addMaskView()
            }
        }
        //个人中心偏移量
        let leftView = window?.subviews.first
        leftView?.x += offset.x * 0.5
        
        // 最大偏移量
        if pan.view!.x >= kPersonalWidth - 1 {
            pan.view?.x = kPersonalWidth - 1
            markView.backgroundColor = UIColor(white: 0, alpha: normalAlpha)
            leftView?.x = 0
        }
        //拖拽结束时
        if pan.state == .ended {
            var offsetX: CGFloat = 0, leftX: CGFloat = 0
            if pan.view!.x >= kScreenW * 0.4 {
                offsetX = kPersonalWidth - 1
                leftX = 0
                maskViewAlpha = normalAlpha
            }
            else {
                offsetX = 0
                leftX = -kPersonalWidth * 0.5
                maskViewAlpha = 0
            }
            
            UIView.animate(withDuration: 0.25, animations: { 
                pan.view?.x = offsetX
                leftView?.x = leftX
                self.markView.backgroundColor = UIColor(white: 0, alpha: self.maskViewAlpha)
            }, completion: { (finished) in
                if pan.view?.x == 0 {
                    self.markView.removeFromSuperview()
                }
            })
        }
        pan.setTranslation(CGPoint.zero, in: pan.view)
    }
    
    //移除拖拽手势
    private func removePersonalPanGesture() {
        kRootVC.view.removeGestureRecognizer(pan)
    }
    
    //添加遮罩
    private func addMaskView() {
        kRootVC.view.addSubview(markView)
    }
}






