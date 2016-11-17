//
//  MusicSearchControl.swift
//  file
//
//  Created by 翟泉 on 2016/11/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicSearchControl: NSObject, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private weak var navigationItem: UINavigationItem!
    private var searchTypeButtonItem: UIBarButtonItem!
    private var tempLeftBarButtonItems: [UIBarButtonItem]?
    
    private var tableView: UITableView!
    private weak var contentInView: UIView!
    
    init(navigationItem: UINavigationItem, contentInView: UIView) {
        super.init()
        self.navigationItem = navigationItem
        self.contentInView = contentInView
        
        searchTypeButtonItem = UIBarButtonItem(title: "单曲", style: .done, target: nil, action: nil)
        
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "搜索单曲、专辑、歌单、歌手"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tempLeftBarButtonItems = navigationItem.leftBarButtonItems
        navigationItem.leftBarButtonItem = searchTypeButtonItem
        searchBar.setShowsCancelButton(true, animated: true)
        showSearchHistory()
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        navigationItem.leftBarButtonItems = tempLeftBarButtonItems
        tempLeftBarButtonItems = nil
        searchBar.setShowsCancelButton(false, animated: true)
        hideSearchHistory()
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text!.lengthOfBytes(using: .utf8) > 0 else {
            return
        }
        addHistory(text: searchBar.text!)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // MARK: - History
    var historys = [String]()
    
    func showSearchHistory() {
        tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        contentInView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentInView)
        }
    }
    func hideSearchHistory() {
        tableView.removeFromSuperview()
    }
    
    func readHistory() {
        guard let obj = UserDefaults.standard.object(forKey: "Music_Search_History") else { return }
        historys = obj as! [String]
    }
    func addHistory(text: String) {
        if historys.contains(text) {
            
        }
        for (idx, str) in historys.enumerated() {
            if str == text {
                historys.remove(at: idx)
                break
            }
        }
        historys.insert(text, at: 0)
        if historys.count > 10 {
            historys.removeLast()
        }
        UserDefaults.standard.set(historys, forKey: "Music_Search_History")
    }
    
    // MARK: - UITableViewProtocol
    /// Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard historys.count > 0 else {
            return 0
        }
        return historys.count + 1
    }
    /// Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "")!
        
        return cell
    }
    
    
    
    
    
    
}
