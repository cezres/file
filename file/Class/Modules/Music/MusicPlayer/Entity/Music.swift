//
//  Music.swift
//  file
//
//  Created by 翟泉 on 2016/10/9.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

public class Music: NSManagedObject {
    
    lazy var url: URL! = {
        let path = HomeDirectory + self.relativePath
        return URL(fileURLWithPath: path)
    }()
    
    @NSManaged public var relativePath: String!
    
    @NSManaged public var song: String?
    @NSManaged public var singer: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var albumName: String?
    @NSManaged public var duration: Double
    
    @NSManaged public var date: NSDate?
    
    @NSManaged public var playCount: Int16
    
    lazy var image: UIImage? = {
        guard let data = self.imageData else {
            return nil
        }
        return UIImage(data: data as Data)
    }()
    
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Music> {
        return NSFetchRequest<Music>(entityName: "Music");
    }
    
    public override var description: String {
        var description = "歌曲名:\(song!)"
        if singer != nil {
            description += "歌手:\(singer!)"
        }
        if albumName != nil {
            description += "专辑名:\(albumName!)"
        }
        return description
    }
    
    func setup(url: URL) {
        self.url = url
        relativePath = url.absoluteString.relativePath.urlDecode
        
        
        playCount = 1
        date = NSDate()
        
        let asset = AVURLAsset(url: url)
        
        duration = TimeInterval(asset.duration.value) / TimeInterval(asset.duration.timescale)
        
        for format in asset.availableMetadataFormats {
            for metadataItem in asset.metadata(forFormat: format) {
                print(metadataItem.commonKey)
                print(metadataItem.dataType)
                if metadataItem.commonKey == "title" {
                    song = metadataItem.value as? String
                }
                else if metadataItem.commonKey == "artist" {
                    singer = metadataItem.value as? String
                }
                else if metadataItem.commonKey == "albumName" {
                    albumName = metadataItem.value as? String
                }
                else if metadataItem.commonKey == "artwork" {
                    if let data = metadataItem.value as? Data {
                        imageData = data as NSData?
                        continue
                    }
                    
                    guard let dict = metadataItem.value as? NSDictionary else {
                        continue
                    }
                    
                    guard let data = dict.object(forKey: "data") as? Data else {
                        continue
                    }
                    image = UIImage(data: data)
                }
            }
        }
        if song == nil || song == "" {
            song = url.lastPathComponent
        }
    }
    
    
}

