//
//  KMNavigationController.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let target = interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        interactivePopGestureRecognizer?.isEnabled = false  //屏蔽系统手势
        
        let navBar = UINavigationBar.appearance(whenContainedInInstancesOf: [KMNavigationController.self])
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.white]
        navBar.titleTextAttributes = attrs
        navBar.barTintColor = RGBA(59, 90, 239, 0.9)
        navBar.isTranslucent = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 { // 非一级界面返回按钮
            viewController.hidesBottomBarWhenPushed = true
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(img: #imageLiteral(resourceName: "back_icon"), target: self, action: #selector(back))
        }
        else { // 一级界面导航栏左边按钮
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(img: #imageLiteral(resourceName: "个人中心"), target: self, action: #selector(showPersonal))
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    //返回
    @objc private func back() {
        popViewController(animated: true)
    }
    
    //展示个人中心
    @objc private func showPersonal() {
        kAppDelegate.showPersonal()
    }
}

// MARK: - 滑动返回手势代理
extension KMNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return childViewControllers.count > 1
    }
}





