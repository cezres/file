//
//  MusicSearchControl.swift
//  file
//
//  Created by 翟泉 on 2016/11/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

/// 音乐搜索
class MusicSearchControl: NSObject, UISearchBarDelegate {
    
    private weak var navigationItem: UINavigationItem!
    private var searchTypeButtonItem: UIBarButtonItem!
    private var tempLeftBarButtonItems: [UIBarButtonItem]?
    private var tempRightBarButtonItems: [UIBarButtonItem]?
    
    
    private weak var contentInView: UIView!
    private var searchBar: UISearchBar!
    private var historyView: MusicSearchHistoryView?
    private var resultView: MusicSearchResultView?
    
    init(navigationItem: UINavigationItem, contentInView: UIView) {
        super.init()
        self.navigationItem = navigationItem
        self.contentInView = contentInView
        searchTypeButtonItem = UIBarButtonItem(title: "单曲", style: .done, target: nil, action: nil)
        searchBar = UISearchBar()
        searchBar.placeholder = "搜索单曲、专辑、歌单、歌手"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        historyView?.removeFromSuperview()
        resultView?.removeFromSuperview()
        historyView = nil
        resultView = nil
        searchBar.text = ""
        searchBar.resignFirstResponder()
        navigationItem.leftBarButtonItems = tempLeftBarButtonItems
        navigationItem.rightBarButtonItems = tempRightBarButtonItems
        tempLeftBarButtonItems = nil
        tempRightBarButtonItems = nil
        searchBar.setShowsCancelButton(false, animated: true)
    }
    /// 将要开始输入
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchHistory()
        
        return true
    }
    /// 将要结束输入
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        /*
        navigationItem.leftBarButtonItems = tempLeftBarButtonItems
        navigationItem.rightBarButtonItems = tempRightBarButtonItems
        tempLeftBarButtonItems = nil
        tempRightBarButtonItems = nil
        searchBar.setShowsCancelButton(false, animated: true)*/
        return true
    }
    /// 点击搜索
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text!.lengthOfBytes(using: .utf8) > 0 else {
            return
        }
        historyView?.addHistory(text: searchBar.text!)
        searchBar.resignFirstResponder()
        showSearchResult()
        resultView?.search(searchBar.text!)
    }
    
    // MARK: - History
    
    /// 显示搜索历史视图
    func showSearchHistory() {
        guard resultView?.superview == nil else { return }
        
        tempLeftBarButtonItems = navigationItem.leftBarButtonItems
        tempRightBarButtonItems = navigationItem.rightBarButtonItems
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        searchBar.setShowsCancelButton(true, animated: true)
        
        historyView = MusicSearchHistoryView(selected: { [weak self](history) in
            guard self != nil else { return }
            self?.searchBar.text = history
            self?.searchBarSearchButtonClicked(self!.searchBar)
        })
        contentInView.addSubview(historyView!)
        historyView!.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(64)
            make.bottom.equalTo(0)
        }
    }
    
    // MARK: - Result
    func showSearchResult() {
        guard resultView?.superview == nil else { return }
        historyView?.removeFromSuperview()
        historyView = nil
        resultView = MusicSearchResultView()
        contentInView.addSubview(resultView!)
        resultView!.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(64)
            make.bottom.equalTo(0)
        }
    }
}

