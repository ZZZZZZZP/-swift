//
//  KMSettingController.swift
//  swift预览
//
//  Created by Roc on 17/2/17.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

private let settingCellID = "settingCellID"

class KMSettingController: UIViewController {

    fileprivate lazy var dataArr = [[["name":"绑定身份证", "image":""],
                        ["name":"修改密码", "image":""],
                        ["name":"意见反馈", "image":""]],
                        [["name":"关于我们", "image":""],
                         ["name":"版本信息", "image":""]]]
    
    fileprivate lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    fileprivate lazy var footerView: UIView = UIView()
    fileprivate lazy var logoutBtn: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kBackgroudColor
        navigationItem.title = "设置"
        
        setupUI()
    }

}

// MARK: - UI界面布局
extension KMSettingController {
    
    fileprivate func setupUI() {
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 45
        tableView.sectionHeaderHeight = 15
        tableView.sectionFooterHeight = 0
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        tableView.register(KMSettingCell.self, forCellReuseIdentifier: settingCellID)
        
        footerView.height = 200
        tableView.tableFooterView = footerView
        footerView.addSubview(logoutBtn)
        
        logoutBtn.layer.cornerRadius = 5
        logoutBtn.layer.masksToBounds = true
        logoutBtn.backgroundColor = kNavColor
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.setTitleColor(UIColor.white, for: .normal)
        logoutBtn.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        
        logoutBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(40)
            make.height.equalTo(50)
        }
        
        logoutBtn.addTarget(self, action: #selector(logoutBtnClick), for: .touchUpInside)
    }
}

// MARK: - tableView协议方法
extension KMSettingController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = dataArr[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCellID) as! KMSettingCell
        cell.textLabel?.text = dict["name"]
        cell.imageView?.image = UIImage(named: dict["image"]!)
        
        if indexPath.section == 1 && indexPath.row == 1 {
            cell.isVersionCell = true
            cell.selectionStyle = .none
        }
        else {
            cell.isVersionCell = false
            cell.selectionStyle = .default
        }
        
        return cell
    }
}

// MARK: - 退出登录
extension KMSettingController {
    
    @objc fileprivate func logoutBtnClick() {
        
        let account = kUserDefaults.string(forKey: kAccountKey)
        let password = kUserDefaults.string(forKey: kPasswordKey)
        let params = ["Mobile": account, "Password": password]
        let url = kBaseURL + "api/App/Logout"
        
        KMNetworkManager.request(url: url, method: .POST, params: params) { (result, error) in
            if result == nil {
                print("网络连接异常")
                return
            }
            let resultDict = result as? [String: Any]
            let status = resultDict?["Status"] as? Int
            
            if status != KMStatusCode.success.rawValue {
                let msg = resultDict?["Msg"] as! String
                print(msg)
                return
            }
            //注销成功
            kUserModel.UserToken = ""
            kUserModel.UserID = ""
            kUserModel.Token = ""
            kNetworkConfig.appToken = ""
            
            kUserDefaults.set(false, forKey: kIsLoginKey)
            kAppDelegate.loginStatus = KMLoginStatus.notLogin.rawValue
            
            self.navigationController!.popViewController(animated: true)
        }
    }
}





