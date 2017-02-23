//
//  String.swift
//  file
//
//  Created by 翟泉 on 2016/10/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - Path
    
    var pathExtension: String {
        
        let array = components(separatedBy: ".")
        guard array.count > 1 else {
            return ""
        }
        return array[array.count - 1]
    }
    
    var lastPathComponent: String {
        let array = components(separatedBy: "/")
        return array[array.count - 1]
    }
    
    /// 相对路径
    var relativePath: String {
        guard let range = range(of: HomeDirectory) else {
            return ""
        }
        let relativePath = substring(from: range.upperBound)
        return relativePath
    }
    
    /// 去掉文件后缀
    var deletingPathExtension: String {
        guard let range = range(of: ".", options: String.CompareOptions.backwards, range: nil, locale: nil) else {
            return self
        }
        return substring(to: range.lowerBound)
    }
    
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    // MARK: - Hash
    
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        CC_MD5(str, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
    
    var urlDecode: String {
        return CFURLCreateStringByReplacingPercentEscapesUsingEncoding(nil, self as CFString!, "" as CFString!, CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue)) as String!
    }
    
}
