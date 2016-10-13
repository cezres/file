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
let FICDPhotoSquareImage32BitBGRAFormatName = "com.path.FastImageCacheDemo.FICDPhotoSquareImage32BitBGRAFormatName"

let FICDPhotoSquareImageSize = CGSize(width: 100, height: 100)


class ImageCache: NSObject, FICImageCacheDelegate {
    
    static var share = ImageCache()
    
    override init() {
        super.init()
        
        var formats = [FICImageFormat]()
        
        let squareImageFormatMaximumCount = 200
        let squareImageFormatDevices = FICImageFormatDevices.phone
        
        let squareImageFormat32BitBGRA = FICImageFormat(name: FICDPhotoSquareImage32BitBGRAFormatName, family: FICDPhotoImageFormatFamily, imageSize: FICDPhotoSquareImageSize, style: FICImageFormatStyle.style32BitBGRA, maximumCount: squareImageFormatMaximumCount, devices: squareImageFormatDevices, protectionMode: FICImageFormatProtectionMode.none)
        
        formats.append(squareImageFormat32BitBGRA!)

        
        FICImageCache.shared().delegate = self
        FICImageCache.shared().setFormats(formats)
        
    }
    
    
    func fileIcon(url: URL, completionBlock: @escaping (_ url: URL, _ image: UIImage) -> Void ) {
        let imageEntity = ImageEntity(url: url)
        FICImageCache.shared().retrieveImage(for: imageEntity, withFormatName: FICDPhotoSquareImage32BitBGRAFormatName) { (entity, formatName, image) in
            if image != nil {
                completionBlock(url, image!)
            }
        }
    }
    
    func fileMusicIcon(file: File, completionBlock: @escaping (_ url: URL, _ image: UIImage) -> Void ) {
        
        /*
        print(file.relativePath)
        
        let imageEntity = ImageEntity(identifier: file.relativePath)
        let result = FICImageCache.shared().retrieveImage(for: imageEntity, withFormatName: FICDPhotoSquareImage32BitBGRAFormatName) { (entity, formatName, image) in
            if image != nil {
                completionBlock(file.url, image!)
            }
        }
        
        if result {
            return
        }
        
        let cover = MusicModel.cover(for: file.url)
        
        if cover != nil {
//            completionBlock(file.url, cover!)
            
            FICImageCache.shared().setImage(cover!, for: imageEntity, withFormatName: FICDPhotoSquareImage32BitBGRAFormatName, completionBlock: { (entity, formatName, image) in
                if image != nil {
                    completionBlock(file.url, image!)
                }
            })
        }*/
        
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
