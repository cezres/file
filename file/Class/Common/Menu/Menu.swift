//
//  Menu.swift
//  file
//
//  Created by 翟泉 on 2016/10/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class Menu: NSObject {
    
    var navigationBarOffset: CGFloat = 0
    var itemHeight: CGFloat = 44
    var menuHeight: CGFloat = 0
    
    var dataSource = [String]() {
        didSet {
            menuHeight = itemHeight * CGFloat(dataSource.count)
        }
    }
    
    
    var isAnimating = false
    var isOpen = false
    
    func show(view: UIView) {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        isOpen = true
        initViews(view: view)
        
        
        let value = UIViewAnimationOptions.beginFromCurrentState.rawValue | UIViewAnimationOptions.curveEaseInOut.rawValue
        let options = UIViewAnimationOptions(rawValue: value)
        UIView.animate(withDuration: 0.3 + 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: options, animations: {
            self.wrapperView.transform = CGAffineTransform(translationX: 0, y: self.menuHeight + self.navigationBarOffset)
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
            self.collectionView.removeFromSuperview()
            self.wrapperView.removeFromSuperview()
            self.containerView.removeFromSuperview()
            self.collectionView = nil
            self.wrapperView = nil
            self.containerView = nil
        })
    }
    
    
    func tapcCntainerView() {
        close()
    }
    
    private var collectionView: UICollectionView!
    private var wrapperView: UIView!
    private var containerView: UIView!
    
    
    func initViews(view: UIView) {
        containerView = UIView()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(Menu.tapcCntainerView))
//        containerView.addGestureRecognizer(tap)
        
        wrapperView = UIView()
        wrapperView.layer.shadowColor = UIColor.black.cgColor
        wrapperView.layer.shadowOffset = CGSize(width: 0, height: 4)
        wrapperView.layer.shadowOpacity = 0.8
        wrapperView.layer.shadowRadius = 4
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.width, height: itemHeight)
        flowLayout.sectionInset = UIEdgeInsets()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.register(MenuItemView.classForCoder(), forCellWithReuseIdentifier: "MenuItem")
        collectionView.backgroundColor = UIColor.white
        
        
        wrapperView.addSubview(collectionView)
        containerView.addSubview(wrapperView)
        view.addSubview(containerView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(wrapperView)
        }
        wrapperView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(containerView.snp.top)
            make.height.equalTo(menuHeight)
        }
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    
    
}



extension Menu: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItem", for: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = cell as? MenuItemView else {
            return
        }
        item.textLabel.text = dataSource[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
