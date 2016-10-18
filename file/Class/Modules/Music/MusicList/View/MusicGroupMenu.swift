//
//  MusicGroupMenu.swift
//  file
//
//  Created by 翟泉 on 2016/10/14.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicGroupMenu: NSObject/*, UITableViewDataSource, UITableViewDelegate*/ {
    
    
    
    var topOffset: CGFloat = 0
    
    var isAnimating = false
    var isShow = false
    
    var height: CGFloat = 0
    var rowHeight: CGFloat = 44
    
    var groupNames = [String]() {
        didSet {
            height = rowHeight * CGFloat(groupNames.count + 1)
            guard isShow else {
                return
            }
//            tableView.reloadData()
            wrapperView.frame = CGRect(x: 0, y: -height, width: SSize.width, height: height)
            wrapperView.transform.ty = wrapperView.height + topOffset
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show(view: UIView) {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        isShow = true
        initViews(view: view)
        
        
        let value = UIViewAnimationOptions.beginFromCurrentState.rawValue | UIViewAnimationOptions.curveEaseInOut.rawValue
        let options = UIViewAnimationOptions(rawValue: value)
        UIView.animate(withDuration: 0.3 + 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: options, animations: {
            self.wrapperView.transform = CGAffineTransform(translationX: 0, y: self.height + self.topOffset)
        }, completion: { (_) in
            self.isAnimating = false
        })
    }
    
    func close() {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        isShow = false
        
        let value = UIViewAnimationOptions.beginFromCurrentState.rawValue | UIViewAnimationOptions.curveEaseInOut.rawValue
        let options = UIViewAnimationOptions(rawValue: value)
        UIView.animate(withDuration: 0.2, delay: 0, options: options, animations: {
            self.wrapperView.transform = CGAffineTransform.identity
        }, completion: { (_) in
            self.isAnimating = false
            self.collectionView.removeFromSuperview()
            self.wrapperView.removeFromSuperview()
            self.containerView.removeFromSuperview()
            self.collectionView = nil
            self.wrapperView = nil
            self.containerView = nil
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupNames.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group")!
        
        if indexPath.row == groupNames.count {
            cell.textLabel?.text = "创建分组"
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = ColorRGB(61, 168, 68)
        }
        else {
            cell.textLabel?.text = groupNames[indexPath.row]
            cell.textLabel?.textColor = ColorWhite(34)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tapcCntainerView() {
        close()
    }
    
//    private var tableView: UITableView!
    private var collectionView: UICollectionView!
    private var wrapperView: UIView!
    private var containerView: UIView!
    
    
    func initViews(view: UIView) {
        
        containerView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(MusicGroupMenu.tapcCntainerView))
        containerView.addGestureRecognizer(tap)
        
        
        wrapperView = UIView()
        wrapperView.layer.shadowColor = UIColor.black.cgColor
        wrapperView.layer.shadowOffset = CGSize(width: 0, height: 4)
        wrapperView.layer.shadowOpacity = 0.8
        wrapperView.layer.shadowRadius = 4
        
        /*
        tableView = UITableView(frame: CGRect(), style: .plain)
        tableView.rowHeight = rowHeight
        tableView.register(MusicGroupTableViewCell.classForCoder(), forCellReuseIdentifier: "Group")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets()
        tableView.layoutMargins = UIEdgeInsets()*/
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.width, height: 44)
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        
        
        wrapperView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(wrapperView)
        }
        
        containerView.addSubview(wrapperView)
        wrapperView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(containerView.snp.top)
            make.height.equalTo(height)
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
    
}


extension MusicGroupMenu: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupNames.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Group", for: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = cell else {
//            return
//        }
        
        
    }
    
}
