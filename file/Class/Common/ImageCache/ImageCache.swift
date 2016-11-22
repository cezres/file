//
//  ImageCache.swift
//  file
//
//  Created by 翟泉 on 2016/10/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import FastImageCache

let FICDPhotoImageFormatFamily = "FICDPhotoImageFormatFamily"


enum ImageCacheFormat: String {
    case fileIcon = "com.cezres.file.FIC.fileIcon"
}


class ImageCache: NSObject, FICImageCacheDelegate {
    
    static var share = ImageCache()
    
    override init() {
        super.init()
        
        var formats = [FICImageFormat]()
        
        
        let fileIconImageFormat = FICImageFormat(name: ImageCacheFormat.fileIcon.rawValue, family: FICDPhotoImageFormatFamily, imageSize: CGSize(width: 64, height: 64), style: .style32BitBGRA, maximumCount: 200, devices: .phone, protectionMode: .none)
        formats.append(fileIconImageFormat!)

        
        FICImageCache.shared().delegate = self
        FICImageCache.shared().setFormats(formats)
        
    }
    
    
    func retrieveImage(url: URL, format: ImageCacheFormat, completionBlock: @escaping (_ url: URL, _ image: UIImage) -> Void) -> Bool {
        let entity = ImageEntity(url: url)
        let result = FICImageCache.shared().retrieveImage(for: entity, withFormatName: format.rawValue) { (_, _, image) in
            if let image = image {
                completionBlock(url, image)
            }
        }
        return result
    }
    
    @discardableResult class func retrieveImage(url: URL, format: ImageCacheFormat, completionBlock: @escaping (_ url: URL, _ image: UIImage) -> Void) -> Bool {
        return ImageCache.share.retrieveImage(url: url, format: format, completionBlock: completionBlock)
    }
    
    

    // MARK: - FICImageCacheDelegate
    func imageCache(_ imageCache: FICImageCache!, errorDidOccurWithMessage errorMessage: String!) {
        print(#function)
    }
    func imageCache(_ imageCache: FICImageCache!, cancelImageLoadingFor entity: FICEntity!, withFormatName formatName: String!) {
        print(#function)
    }
    func imageCache(_ imageCache: FICImageCache!, shouldProcessAllFormatsInFamily formatFamily: String!, for entity: FICEntity!) -> Bool {
        print(#function)
        return false
    }
    func imageCache(_ imageCache: FICImageCache!, wantsSourceImageFor entity: FICEntity!, withFormatName formatName: String!, completionBlock: FICImageRequestCompletionBlock!) {
        print(#function)
        OperationQueue().addOperation { 
            guard let url = entity.sourceImageURL(withFormatName: formatName) else {
                return
            }
            var data: Data!
            do {
                data = try Data(contentsOf: url)
            }
            catch {
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            completionBlock(image)
        }
    }
    
}
