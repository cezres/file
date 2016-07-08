//
//  MusicEntity.swift
//  file
//
//  Created by 翟泉 on 2016/7/2.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct MusicEntity {
    
    let path: String    // 路径
    
    let name: String
    // 歌曲名
    var song: String!
    var singer: String! // 歌手
    var image: UIImage! // 图片
    var albumName: String!  // 专辑名
    
    var duration: TimeInterval = 0
    
    
    init(path: String) {
        self.path = path
        
        name = (NSString(string: path).lastPathComponent as NSString).deletingPathExtension
        
        
        
        
        let url = URL(fileURLWithPath: path)
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
        if song == nil {
            song = name
        }
        
    }
    
}


extension MusicEntity: CustomStringConvertible {
    var description: String {
        return "歌曲名:\(song) 歌手:\(singer) 专辑名:\(albumName)"
    }
}


