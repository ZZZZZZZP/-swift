//
//  KMNetworkConfig.swift
//  swift预览
//
//  Created by 张鹏 on 2017/2/14.
//  Copyright © 2017年 zp. All rights reserved.
//

import Foundation

enum KMEnvironment {
    case test         // 测试环境
    case development  // 开发环境
    case production   // 生产环境
}

private let appKey = "@KMG@KM2016#0825"
private let kRandomAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
private let kRandomLength = 12

//APP环境
private let environment: KMEnvironment = .production

let kBaseURL = kNetworkConfig.urlOfEnvironment(environment)

class KMNetworkConfig {
    
    static let sharedInstance = KMNetworkConfig()
    
    var appToken: String = ""
    
    fileprivate func urlOfEnvironment(_ environment: KMEnvironment) -> String {
        
        var baseURL = ""
        switch environment {
        case .test:
            baseURL = "http://120.77.49.54:9003/"
        case .development:
            baseURL = "http://120.77.49.54:1225/"
        case .production:
            baseURL = "http://www.kmhealthstation.com/"
        }
        
        return baseURL
    }
    
}

// MARK: - 生成随机字符串
extension KMNetworkConfig {
    
    func generateRandomString() -> String {
        
        var randomString = ""
        randomString.reserveCapacity(kRandomLength)
        
        for _ in 0..<kRandomLength {
            let c = (kRandomAlphabet as NSString).character(at: Int(arc4random_uniform(UInt32(kRandomAlphabet.characters.count))))
            randomString.append(String(format: "%c", c))
        }
        return randomString
    }
}

// MARK: - 生成签名根据随机字符串
extension KMNetworkConfig {
    
    func generateSignature(randomString: String) -> String {
        
        let appToken = kNetworkConfig.appToken
        let userToken = kUserModel.UserToken
        
        let str = String(format: "apptoken=%@&noncestr=%@%@&appkey=%@", arguments: [appToken, randomString, (userToken == "" ? "" : String(format: "&usertoken=%@", userToken)), appKey])
        
        return str.md5String().uppercased()
    }
}





