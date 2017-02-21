//
//  FileFunctions.swift
//  file
//
//  Created by 翟泉 on 2017/2/21.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import Foundation
import AVFoundation
import MobileCoreServices

func MIMEType(pathExtension: String) -> String? {
//    guard FileManager.default.fileExists(atPath: url.path) else {
//        return nil
//    }
    guard let UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeUnretainedValue() else {
        return nil
    }
    let MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType)?.takeUnretainedValue() as? String
    return MIMEType
}

