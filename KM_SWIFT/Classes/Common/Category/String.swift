//
//  String.swift
//  swift预览
//
//  Created by Roc on 17/2/16.
//  Copyright © 2017年 zp. All rights reserved.
//

extension String {
    
    func md5String() -> String {
        
        let cStr = self.cString(using: String.Encoding.utf8)
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), result)
        
        var md5String = ""
        for i in 0..<digestLen{
            md5String += String(format: "%02x", result[i])
        }
        free(result)
        return md5String as String
    }
    
    func md5String11() -> String {
        
        let cStr = self.cString(using: String.Encoding.utf8)
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        CC_MD5(cStr!, strLen, result)
        
        var md5String = ""
        for i in 0..<digestLen {
            md5String += String(format: "%02x", result[i])
        }
        result.deinitialize()
        return String(format: md5String as String)
    }
}
