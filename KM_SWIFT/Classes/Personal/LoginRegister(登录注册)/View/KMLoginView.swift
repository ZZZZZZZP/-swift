//
//  KMLoginView.swift
//  swift预览
//
//  Created by Roc on 17/2/14.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

// MARK: - 对外接口
protocol KMLoginViewDelegate {
    func login(loginView: KMLoginView, mobile: String, password: String)
    func forgetPassword(loginView: KMLoginView)
}

// MARK: - 定义类
class KMLoginView: UIView {
    
    var delegate: KMLoginViewDelegate?
    
    // MARK: - 懒加载属性
    fileprivate lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.image = #imageLiteral(resourceName: "logo")
        return logoImgView
    }()
    
    fileprivate lazy var accountTF: UITextField = {[weak self] in
        return self!.creatTextField(imgName: "my")
    }()
    fileprivate lazy var pswTF: UITextField = {[weak self] in
        let pswTF = self!.creatTextField(imgName: "password")
        pswTF.isSecureTextEntry = true
        return pswTF
    }()
    
    fileprivate lazy var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(#imageLiteral(resourceName: "login"), for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(UIColor("09addc"), for: .normal)
        loginBtn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        
        return loginBtn
    }()
    
    fileprivate lazy var forgetBtn: UIButton = {
        let forgetBtn = UIButton()
        forgetBtn.setTitle("忘记密码?", for: .normal)
        forgetBtn.setTitleColor(UIColor.white, for: .normal)
        forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        forgetBtn.addTarget(self, action: #selector(forgetPasswordClick), for: .touchUpInside)
        
        return forgetBtn
    }()
    
    // MARK: - 入口
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.contents = #imageLiteral(resourceName: "Login_bg").cgImage
        setupUI()
        layoutChildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 按钮点击事件
extension KMLoginView {
    
    @objc fileprivate func loginClick() {
        delegate?.login(loginView: self, mobile: accountTF.text!, password: pswTF.text!)
    }
    
    @objc fileprivate func forgetPasswordClick() {
        delegate?.forgetPassword(loginView: self)
    }
}

// MARK: - textField协议
extension KMLoginView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == pswTF {
            textField.returnKeyType = .done
        }else {
            textField.returnKeyType = .next
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTF {
            pswTF.becomeFirstResponder()
        }else {
            pswTF.resignFirstResponder()
        }
        return true
    }
}

// MARK: - 搭建UI界面
extension KMLoginView {
    
    fileprivate func setupUI() {
        
        addSubview(logoImgView)
        addSubview(loginBtn)
        addSubview(forgetBtn)
    }
    
    fileprivate func layoutChildViews() {
        
        logoImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 70, height: 70))
            make.top.equalTo(112 * kFitWidthScale)
            make.centerX.equalToSuperview()
        }
        accountTF.superview?.snp.makeConstraints({ (make) in
            make.top.equalTo(logoImgView.snp.bottom).offset(83 * kFitWidthScale)
            make.left.equalTo(43)
            make.right.equalTo(-43)
            make.height.equalTo(40 * kFitWidthScale)
        })
        pswTF.superview?.snp.makeConstraints({ (make) in
            make.size.equalTo(accountTF.superview!)
            make.top.equalTo(accountTF.superview!.snp.bottom).offset(30 * kFitWidthScale)
            make.centerX.equalToSuperview()
        })
        loginBtn.snp.makeConstraints { (make) in
            make.size.equalTo(accountTF.superview!)
            make.top.equalTo(pswTF.superview!.snp.bottom).offset(35 * kFitWidthScale)
            make.centerX.equalToSuperview()
        }
        forgetBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 80, height: 19))
            make.top.equalTo(loginBtn.snp.bottom).offset(30 * kFitWidthScale)
            make.right.equalTo(loginBtn)
        }
    }
    
    //创建textFiled
    fileprivate func creatTextField(imgName: String) -> UITextField {
        
        let superView = UIView()
        superView.layer.contents = #imageLiteral(resourceName: "input").cgImage
        let icon = UIImageView()
        icon.image = UIImage(named: imgName)
        superView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 15, height: 17.5))
            make.left.equalTo(23);
            make.centerY.equalToSuperview()
        }
        
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.white
        textField.delegate = self
        superView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(15);
            make.right.equalTo(0);
            make.height.equalTo(superView);
            make.centerY.equalToSuperview()
        }
        addSubview(superView)
        
        return textField
    }
}









