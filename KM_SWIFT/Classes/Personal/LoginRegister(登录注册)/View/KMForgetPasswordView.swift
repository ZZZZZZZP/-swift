//
//  KMForgetPasswordView.swift
//  swift预览
//
//  Created by Roc on 17/2/16.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

// MARK: - 对外接口
protocol KMForgetPasswordViewDelegate {
    func getCode(forgetPasswordView: KMForgetPasswordView, mobile: String)
    func resetPassword(forgetPasswordView: KMForgetPasswordView, mobile: String, code: String, password: String)
}

// MARK: - 定义类
class KMForgetPasswordView: UIView {

    var delegate: KMForgetPasswordViewDelegate?
    fileprivate var timer: Timer?
    var getCodeSuccess: (()->())?
    
    // MARK: - 懒加载属性
    fileprivate lazy var accountTF: UITextField = {[weak self] in
        return self!.textField(placeholder: "请输入手机号")
        }()
    fileprivate lazy var codeTF: UITextField = {[weak self] in
        return self!.textField(placeholder: "获取验证码")
        }()
    fileprivate lazy var pswTF: UITextField = {[weak self] in
        let pswTF = self!.textField(placeholder: "请输入新密码")
        pswTF.isSecureTextEntry = true
        return pswTF
        }()
    
    fileprivate lazy var getCodeBtn: UIButton = {
        let getCodeBtn = UIButton()
        getCodeBtn.backgroundColor = kNavColor
        getCodeBtn.setTitle("获取验证码", for: .normal)
        getCodeBtn.setTitleColor(UIColor.white, for: .normal)
        getCodeBtn.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        getCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        getCodeBtn.layer.cornerRadius = 2
        getCodeBtn.layer.masksToBounds = true
        getCodeBtn.addTarget(self, action: #selector(getCodeClick), for: .touchUpInside)
        
        return getCodeBtn
    }()
    
    fileprivate lazy var confirmBtn: UIButton = {
        let confirmBtn = UIButton()
        confirmBtn.backgroundColor = kNavColor
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.layer.masksToBounds = true
        confirmBtn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        
        return confirmBtn
    }()
    
    // MARK: - 入口
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = kBackgroudColor
        setupUI()
        layoutChildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 按钮点击事件
extension KMForgetPasswordView {
    
    @objc fileprivate func getCodeClick() {
        delegate?.getCode(forgetPasswordView: self, mobile: accountTF.text!)
        getCodeSuccess = {
            self.addTimer()
        }
    }
    
    @objc fileprivate func confirmClick() {
        delegate?.resetPassword(forgetPasswordView: self, mobile: accountTF.text!, code: codeTF.text!, password: pswTF.text!)
    }
}

// MARK: - 操作定时器
private var downCount = 30
extension KMForgetPasswordView {
    
    fileprivate func addTimer() {
        
        getCodeBtn.isEnabled = false
        getCodeBtn.setTitle("30秒可获取", for: .normal)
        timer = Timer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    private func removeTimer() {
        getCodeBtn.isEnabled = true
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func countDown() {
        downCount -= 1
        if downCount == 0 {
            downCount = 30
            getCodeBtn.setTitle("获取验证码", for: .normal)
            removeTimer()
        }
        else{
            getCodeBtn.setTitle("\(downCount)秒可获取", for: .normal)
        }
    }
}

// MARK: - textField协议
extension KMForgetPasswordView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == pswTF {
            textField.returnKeyType = .done
        }
        else {
            textField.returnKeyType = .next
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTF {
            codeTF.becomeFirstResponder()
        }
        else if textField == codeTF {
            pswTF.becomeFirstResponder()
        }
        else if textField == pswTF {
            pswTF.resignFirstResponder()
        }
        return true
    }
}

// MARK: - 搭建UI界面
extension KMForgetPasswordView {
    
    fileprivate func setupUI() {
        
        addSubview(accountTF)
        addSubview(codeTF)
        addSubview(pswTF)
        addSubview(getCodeBtn)
        addSubview(confirmBtn)
        
    }
    
    fileprivate func layoutChildViews() {
        
        accountTF.snp.makeConstraints { (make) in
            make.top.equalTo(84)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(50 * kFitHeightScale)
        }
        codeTF.snp.makeConstraints { (make) in
            make.size.equalTo(accountTF)
            make.top.equalTo(accountTF.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        pswTF.snp.makeConstraints { (make) in
            make.size.equalTo(accountTF);
            make.top.equalTo(codeTF.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        getCodeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(kSize(90 * kFitWidthScale, 30 * kFitWidthScale))
            make.right.equalTo(codeTF.snp.right).offset(-15)
            make.centerY.equalTo(codeTF)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(accountTF)
            make.top.equalTo(pswTF.snp.bottom).offset(35 * kFitHeightScale)
            make.centerX.equalToSuperview()
        }
    }
    
    fileprivate func textField(placeholder: String) -> UITextField {
        
        let textField = UITextField()
        textField.leftView = UIView(frame: kRect(0, 0, 10, 0))
        textField.leftViewMode = .always
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor.white
        textField.textColor = RGB(51, 51, 51)
        textField.delegate = self
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        
        return textField
    }
}









