//
//  FileListViewModel.swift
//  file
//
//  Created by 翟泉 on 16/4/5.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import ReactiveCocoa

protocol FileListViewModelProtocol {
    /**
     移除文件Cell
     - parameter index: <#index description#>
     */
    func removeAt(index: Int)
}

class FileListViewModel {
    
    var title: String = ""
    // 文件列表
    var files = [File]()
    
    // 目录路径
    private let directoryPath: String
    // 文件列表服务
    private var services = FileListServices()
    
    // MARK: Signal
    // 刷新界面信号
    let reloadSignal = RACSubject()
    // 标题
    let titleSignal = RACSubject()
    
    /**
     初始化
     
     - parameter directoryPath: 目录路径
     
     */
    init(directoryPath: String) {
        self.directoryPath = directoryPath
    }
    
    /**
     加载文件列表
     */
    func loadFileList() {
        
        
        
        services.traverseDirectory(directoryPath) { [unowned self](file) in
            self.files.append(file)
        }
        
        self.files.sortInPlace { (f1, f2) -> Bool in
            return f1.type < f2.type
        }
        
        reloadSignal.sendNext(true)
    }
    
    /**
     选中文件
     
     - parameter index: 索引
     */
    func didSelectFileAtIndex(index: Int, controller: UIViewController) {
        switch files[index].type {
        case .Photo:
            var selectedIndex = 0
            var urls = [NSURL]()
            for (idx,file) in files.enumerate() {
                if file.type == .Photo {
                    urls.append(NSURL(fileURLWithPath: file.path))
                }
                if idx == index {
                    selectedIndex = urls.count-1
                }
            }
            controller.navigationController?.pushViewController(ESPhotoViewerViewController(urls: urls, selectedIndex: selectedIndex), animated: true)
            break
        case .Audio:
            AudioPlayerManager.sharedInstance.play(files[index].relativePath)
            break
        case .Video:
            var dict = [NSObject : AnyObject]()
            if files[index].pathExtension == "wmv" {
                dict[KxMovieParameterMinBufferedDuration] = NSNumber(float: 5.0)
            }
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
                dict[KxMovieParameterDisableDeinterlacing] = NSNumber(bool: true)
            }
            let KxMovie = KxMovieViewController.movieViewControllerWithContentPath(files[index].path, parameters: dict as [NSObject : AnyObject]) as! UIViewController
            controller.presentViewController(KxMovie, animated: true, completion: nil)
            break
        case .Directory:
            controller.navigationController?.pushViewController(FileListViewController(directoryPath: files[index].path), animated: true)
            break
        default:
            break
        }
    }
    
}
