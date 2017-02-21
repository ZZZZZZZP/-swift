//
//  KMPersonalController.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

private var myContext = 0
private let kLoginStatusKey = "loginStatus"
private let kPersonalCellID = "kPersonalCellID"

class KMPersonalController: UIViewController {

    lazy var dataArr: [[String: Any]] = {
        let dataArr = [["name":"会员资料",
                        "image":"icon_08"],
                       ["name":"我的服务",
                        "image":"icon_05"],
                       ["name":"我的消息",
                        "image":"icon_10"],/*
                       ["name":"我的订单",
                        "image":"icon_12"],
                       ["name":"我的收藏",
                        "image":"icon_14"],*/
                       ["name":"我的设备",
                        "image":"icon_16"],
                       ["name":"设置",
                        "image":"icon_18"],
                       ]
        return dataArr
    }()
    
    // MARK: - 懒加载属性
    lazy var tableView = UITableView()
    lazy var topView = UIView()
    lazy var iconImgView = UIImageView()
    lazy var loginBtn = UIButton()
    lazy var userInfoView = UIView()
    lazy var nameLabel = UILabel()
    lazy var versionLabel = UILabel()
    
    // MARK: - viewDidLoad回调
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupUI()
        layoutChildViews()
        
        kAppDelegate.addObserver(self, forKeyPath: kLoginStatusKey, options: [.old, .new], context: &myContext)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        iconImgView.layer.cornerRadius = iconImgView.width * 0.5
        iconImgView.layer.masksToBounds = true
    }
    
    //移除KVO
    deinit {
        kAppDelegate.removeObserver(self, forKeyPath: kLoginStatusKey, context: &myContext)
    }
}

// MARK: - KVO监听实现
extension KMPersonalController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch kAppDelegate.loginStatus {
        case KMLoginStatus.notLogin.rawValue:
            
            loginBtn.isHidden = false
            versionLabel.isHidden = false
            userInfoView.isHidden = true
            tableView.isHidden = true
            
        case KMLoginStatus.logging.rawValue:
            
            loginBtn.isHidden = true
            userInfoView.isHidden = false
            nameLabel.text = "正在登录中..."
            
        case KMLoginStatus.success.rawValue:
            
            versionLabel.isHidden = true
            tableView.isHidden = false
            nameLabel.text = kUserModel.UserCNName
            //发送登录通知
            let loginSuccess = Notification.Name(rawValue: kLoginSuccessNotification)
            NotificationCenter.default.post(name: loginSuccess, object: self, userInfo: ["key" : (KMDateModel.current)])
            
        case KMLoginStatus.failure.rawValue:
            kAppDelegate.loginStatus = KMLoginStatus.notLogin.rawValue
            
        default: break
            
        }
    }
    
}

// MARK: - 设置UI界面
extension KMPersonalController {
    
    fileprivate func setupUI() {
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        tableView.register(KMPersonalCell.self, forCellReuseIdentifier: kPersonalCellID)
        
        view.addSubview(topView)
        topView.layer.contents = #imageLiteral(resourceName: "bg").cgImage
        
        topView.addSubview(iconImgView)
        iconImgView.backgroundColor = UIColor.orange
        topView.addSubview(userInfoView)
        topView.addSubview(loginBtn)
        loginBtn.setImage(#imageLiteral(resourceName: "personal_signin_button"), for: .normal)
        loginBtn.setImage(#imageLiteral(resourceName: "personal_signin_button_pre"), for: .highlighted)
        loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        
        userInfoView.addSubview(nameLabel)
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        
        //版本号
        view.addSubview(versionLabel)
        let app_Version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        versionLabel.text = "当前版本：V" + app_Version
        versionLabel.textAlignment = .center
        versionLabel.textColor = RGB(166, 170, 171)
    }
    
    fileprivate func layoutChildViews() {
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(200 * kFitHeightScale)
        }
        iconImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(69 * kFitWidthScale)
            make.centerX.equalToSuperview()
            make.top.equalTo(49.5 * kFitHeightScale)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 130 * kFitWidthScale, height: 35 * kFitWidthScale))
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImgView.snp.bottom).offset(20 * kFitHeightScale)
        }
        userInfoView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(iconImgView.snp.bottom)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(userInfoView)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.left.equalTo(29)
            make.right.equalTo(-29)
            make.bottom.equalTo(0)
        }
        versionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(30)
            make.bottom.equalTo(-30)
        }
    }
}

// MARK: - tableView数据源和代理
extension KMPersonalController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kPersonalCellID) as! KMPersonalCell
        cell.textLabel?.text = dict["name"] as? String
        cell.imageView?.image = UIImage(named: dict["image"] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc: UIViewController?
        
        switch indexPath.row {
        case 0: vc = nil
        case 1: vc = nil
        case 2: vc = nil
        case 3: vc = nil
        case 4: vc = KMSettingController()
        case 5: vc = nil
            
        default: break
            
        }
        if vc == nil {
            return
        }
        push(vc: vc!, animated: true)
    }
}

// MARK: - 登录
extension KMPersonalController {
    
    @objc fileprivate func loginBtnClick() {
        
        let nav = KMNavigationController(rootViewController: KMLoginController())
        kRootVC.present(nav, animated: true) { 
            kAppDelegate.hidePersonal()
        }
    }
}

// MARK: - 此界面push方法
extension KMPersonalController {
    
    fileprivate func push(vc: UIViewController, animated: Bool) {
        
        kAppDelegate.hidePersonal()
        let tabBarVC = kRootVC as! UITabBarController
        let nav = tabBarVC.childViewControllers[tabBarVC.selectedIndex] as? UINavigationController
        nav?.pushViewController(vc, animated: animated)
    }
}






