//
//  MusicSearchHistoryView.swift
//  file
//
//  Created by 翟泉 on 2016/11/18.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

/// 音乐搜索历史视图
class MusicSearchHistoryView: UITableView, UITableViewDataSource, UITableViewDelegate {

    func addHistory(text: String) {
        for (idx, str) in historys.enumerated() {
            if str == text {
                historys.remove(at: idx)
                break
            }
        }
        historys.insert(text, at: 0)
        if historys.count > 20 {
            historys.removeLast()
        }
        UserDefaults.standard.set(historys, forKey: "Music_Search_History")
    }
    
    var historys = [String]()
    
    let selected: ( (String) -> Void )
    
    init(selected: @escaping (String) -> Void) {
        self.selected = selected
        super.init(frame: CGRect(), style: .grouped)
        backgroundColor = UIColor.white
        delegate = self
        dataSource = self
        register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        register(MusicSearchHistoryHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "header")
        register(MusicSearchHistoryFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "footer")
        
        guard let obj = UserDefaults.standard.array(forKey: "Music_Search_History") else { return }
        historys = obj as! [String]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearHistory() {
        historys = []
        reloadData()
        UserDefaults.standard.set(nil, forKey: "Music_Search_History")
    }
    
    
    /// Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historys.count
    }
    /// Size
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return historys.count > 0 ? 30 : 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return historys.count > 0 ? 50 : 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    /// Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = historys[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor(white: 86/255.0, alpha: 1.0)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer") as! MusicSearchHistoryFooterView
        footer.addTarget(self, action: #selector(MusicSearchHistoryView.clearHistory))
        footer.isHidden = historys.count == 0
        return footer
    }
    /// Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selected(historys[indexPath.row])
    }
    
}


fileprivate class MusicSearchHistoryHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let label = UILabel()
        label.text = "历史搜索"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.black
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(4)
            make.bottom.equalTo(-4)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class MusicSearchHistoryFooterView: UITableViewHeaderFooterView {
    var clearButton: UIButton!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        clearButton = UIButton(type: .system)
        clearButton.setTitle("清空历史搜索", for: .normal)
        clearButton.setTitleColor(UIColor(white: 86/255.0, alpha: 1), for: .normal)
        clearButton.layer.cornerRadius = 4
        clearButton.layer.masksToBounds = true
        clearButton.layer.borderColor = UIColor(white: 86/255.0, alpha: 1).cgColor
        clearButton.layer.borderWidth = 0.5
        addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.6)
            make.top.equalTo(15)
            make.height.equalTo(35)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addTarget(_ target: Any?, action: Selector) {
        clearButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
