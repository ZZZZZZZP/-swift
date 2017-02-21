//
//  KMNetworkManager.swift
//  swift预览
//
//  Created by Roc on 17/2/14.
//  Copyright © 2017年 zp. All rights reserved.
//

import Alamofire

enum KMStatusCode: Int {
    case success = 0                  //成功
    case exception = 1                //异常
    case tokenVerificationFailed = 2  //获取token时验证失败
    case illegalRequest = 3           //非法请求
    case modelVerificationFailed = 4  //模型数据验证失败
    case appTokenOutTime = 5          //token失效或过期
    case userIsNotLogin = 6           //用户未登陆
    case noPermission = 7             //无权限
}

enum KMLoginStatus: Int {
    case failure = -1                 //登录失败
    case success = 0                  //登录成功
    case notLogin = 1                 //未登录
    case logging = 2                  //自动登录中...
}

enum KMMethod {
    case GET
    case POST
}

class KMNetworkManager {
//    static let sharedInstance = KMNetworkManager()
    fileprivate static let manager: SessionManager = {
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        let manager = SessionManager(configuration: config)
        
        return manager
    }()
    
    fileprivate static func getHeaders() -> HTTPHeaders {
        let randomString = kNetworkConfig.generateRandomString()
        let signString = kNetworkConfig.generateSignature(randomString: randomString)
        
        return ["apptoken": kNetworkConfig.appToken,
                "noncestr": randomString,
                "usertoken": kUserModel.UserToken,
                "Token": kUserModel.Token,
                "sign": signString]
    }
    
}

// MARK: - 登录状态通用网络请求(与用户相关请求)
extension KMNetworkManager {
    
    static func request(url: String, method: KMMethod = .GET, params: [String: Any]? = nil, finishedBack: @escaping (_ result: Any?, _ error: Error?)->()) {
        
        let httpMethod: HTTPMethod = (method == .GET) ? .get : .post
        let headers: HTTPHeaders = getHeaders()
        
        manager.request(url, method: httpMethod, parameters: params, headers: headers).responseJSON { (response: DataResponse<Any>) in
            
            if response.result.isFailure {
                finishedBack(nil, response.result.error)
                return
            }
            let resultDict = response.result.value as? [String: Any]
            let status = resultDict?["Status"] as? Int
            
            if status != KMStatusCode.appTokenOutTime.rawValue {
                finishedBack(response.result.value, nil)
                return
            }
            //token失效过期的处理
            requestAppToken(finishedBack: { (result, error) in
                if result == nil {  //三次请求token都失败
                    finishedBack(nil, error)
                    return
                }
                //token成功，重新请求数据
                request(url: url, method: method, params: params, finishedBack: finishedBack)
            })
        }
    }
}

//登录和APPtoken请求
private var requestAppTokenCount = 3
extension KMNetworkManager {
    
    //请求token(三次机会)
    fileprivate static func requestAppToken(finishedBack: @escaping (_ result: Any?, _ error: Error?)->()) {
        
        let url = kBaseURL + "api/APP/APPToken"
        let params = ["appId":"OMGA", "appSecret":"OMGA@KM2016"]
        //let headers: HTTPHeaders = getHeaders()
        
        manager.request(url, parameters: params).responseJSON { (response: DataResponse<Any>) in
            
            let resultDict = response.result.value as? [String: Any]
            let status = resultDict?["Status"] as? Int
            
            if response.result.isSuccess {
                if status == KMStatusCode.success.rawValue {
                    let dataDict = resultDict?["Data"] as? [String: Any]
                    kNetworkConfig.appToken = dataDict?["Token"] as! String
                    finishedBack(resultDict, nil)
                    return
                }
            }
            requestAppTokenCount -= 1
            if requestAppTokenCount > 0 {
                requestAppToken(finishedBack: finishedBack)
                return
            }
            //三次请求失败处理
            if resultDict == nil {
                finishedBack(nil, response.result.error)
            }
            else {
                let domin = resultDict?["Msg"] as! String
                let code = status!
                let error = NSError(domain: domin, code: code, userInfo: nil) as Error
                finishedBack(nil, error)
            }
        }
    }
    
    //登录请求
    static func login(account: String, password: String, finishedBack: @escaping (_ result: Any?, _ error: Error?)->()) {
        //请求appToken
        requestAppToken { (result, error) in
            if result == nil {
                finishedBack(nil, error)
                return
            }
            //请求token成功再登录
            let url = kBaseURL + "api/App/Login"
            let params = ["Mobile": account, "Password": password, "UserType": "1", "OrgID": "kmsd", "AppType": "IOS"]
            let headers: HTTPHeaders = getHeaders()
            
            manager.request(url, method: .post, parameters: params, headers: headers).responseJSON(completionHandler: { (response: DataResponse<Any>) in
                
                if response.result.isSuccess {
                    finishedBack(response.result.value, nil)
                }
                else {
                    finishedBack(nil, response.result.error)
                }
            })
        }
    }
    
}






