//
//  Menu.swift
//  file
//
//  Created by 翟泉 on 2016/10/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

protocol MenuDelegate: NSObjectProtocol {
    func menu(_ menu: Menu, didSelectRowAt index: Int)
}

class Menu: NSObject {
    
    var navigationBarOffset: CGFloat = 0
    
    var items = [MenuItem]()
    
    weak var delegate: MenuDelegate?
    
    
    var isAnimating = false
    var isOpen = false
    
    
    func removeItem(idx: Int) {
        let item = items.remove(at: idx)
        
        tableView.deleteRows(at: [IndexPath(row: idx, section: 0)], with: .right)
        
        UIView.animate(withDuration: 1) {
            self.wrapperView.snp.updateConstraints { (make) in
                make.height.equalTo(self.wrapperView.height - item.height)
            }
        }
    }
    func insertItem(_ item: MenuItem, at idx: Int) {
        items.insert(item, at: idx)
        
        tableView.insertRows(at: [IndexPath(row: idx, section: 0)], with: .left)
        
        UIView.animate(withDuration: 1) {
            self.wrapperView.snp.updateConstraints { (make) in
                make.height.equalTo(self.wrapperView.height + item.height)
            }
        }
    }
    
    
    
    func show(view: UIView) {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        isOpen = true
        initViews(view: view)
        
        
        let value = UIViewAnimationOptions.beginFromCurrentState.rawValue | UIViewAnimationOptions.curveEaseInOut.rawValue
        let options = UIViewAnimationOptions(rawValue: value)
        wrapperView.layoutIfNeeded()
        UIView.animate(withDuration: 0.3 + 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: options, animations: {
            self.wrapperView.transform = CGAffineTransform(translationX: 0, y: self.wrapperView.height + self.navigationBarOffset)
        }, completion: { (_) in
            self.isAnimating = false
        })
    }
    
    func close() {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        isOpen = false
        
        let value = UIViewAnimationOptions.beginFromCurrentState.rawValue | UIViewAnimationOptions.curveEaseInOut.rawValue
        let options = UIViewAnimationOptions(rawValue: value)
        UIView.animate(withDuration: 0.2, delay: 0, options: options, animations: {
            self.wrapperView.transform = CGAffineTransform.identity
        }, completion: { (_) in
            self.isAnimating = false
            self.tableView.removeFromSuperview()
            self.wrapperView.removeFromSuperview()
            self.containerView.removeFromSuperview()
            self.tableView = nil
            self.wrapperView = nil
            self.containerView = nil
        })
    }
    
    
    func tapcCntainerView() {
        close()
    }
    
    private var tableView: UITableView!
    private var wrapperView: UIView!
    private var containerView: UIButton!
    
    
    func initViews(view: UIView) {
        var menuHeight: CGFloat = 0
        for item in items {
            menuHeight += item.height
        }
        
        containerView = UIButton(type: .custom)
        containerView.addTarget(self, action: #selector(Menu.tapcCntainerView), for: .touchUpInside)
        
        wrapperView = UIView()
        wrapperView.layer.shadowColor = UIColor.black.cgColor
        wrapperView.layer.shadowOffset = CGSize(width: 0, height: 4)
        wrapperView.layer.shadowOpacity = 0.8
        wrapperView.layer.shadowRadius = 4
        
        tableView = UITableView(frame: CGRect(), style: .plain)
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MenuItemView.classForCoder(), forCellReuseIdentifier: "MenuItem")
        tableView.separatorStyle = .none
        
        
        wrapperView.addSubview(tableView)
        containerView.addSubview(wrapperView)
        view.addSubview(containerView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(wrapperView)
        }
        wrapperView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
//            make.bottom.equalTo(containerView.snp.top)
            make.height.equalTo(menuHeight)
            make.top.equalTo(containerView.snp.top).offset(-menuHeight)
        }
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    
    
}


extension Menu: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return items[indexPath.row].height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "MenuItem")!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = cell as? MenuItemView else {
            return
        }
        item.item = items[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.menu(self, didSelectRowAt: indexPath.row)
    }
    
}
