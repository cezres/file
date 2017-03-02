//
//  FileIconEntity.swift
//  file
//
//  Created by 翟泉 on 2017/2/16.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import FastImageCache
import ESMediaPlayer

class FileIconEntity: NSObject, FICEntity {
    var file: File!
    
    init(file: File) {
        self.file = file
    }
    
    var identifier: String!
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    lazy var _uuid: String = {
        let imageName: String
        if self.file != nil {
            imageName = self.file.name
        }
        else {
            imageName = self.identifier
        }
        
        let UUIDBytes = FICUUIDBytesFromMD5HashOfString(imageName)
        let UUID = FICStringWithUUIDBytes(UUIDBytes)
        return UUID!
    }()
    
    // MARK: - FICEntity
    
    @objc(UUID) var uuid: String! {
        return self._uuid
    }
    
    var sourceImageUUID: String! {
        return self.uuid
    }
    
    func sourceImageURL(withFormatName formatName: String!) -> URL! {
        return file.url
    }
    
    func image(for format: FICImageFormat!) -> UIImage! {
        var image: UIImage?
        switch file.type {
        case .Directory:
            image = UIImage(named: "icon_directory")
        case .Audio:
            image = Music.artwork(url: file.url) ?? UIImage(named: "icon_audio")
        case .Video:
            image = ESMediaPlayerView.thumbnailImage(with: file.url, atTime: 2) ?? UIImage(named: "icon_video")
        case .Photo:
            image = UIImage(contentsOfFile: file.url.path)?.square()
        case .Zip:
            image = UIImage(named: "icon_zip")
        default:
            image = UIImage(named: "icon_unknown")
        }
        return image!
    }
    
    func drawingBlock(for image: UIImage!, withFormatName formatName: String!) -> FICEntityImageDrawingBlock! {
        return { (context: CGContext?, contextSize: CGSize) -> Void in
            
            guard let context = context else {
                return
            }
            
            var contextBounds = CGRect()
            contextBounds.size = contextSize
            context.clear(contextBounds)
            context.setFillColor(UIColor.white.cgColor)
            context.fill(contextBounds)
            
            UIGraphicsPushContext(context)
            image.square().draw(in: contextBounds)
            UIGraphicsPopContext()
        }
    }
}
