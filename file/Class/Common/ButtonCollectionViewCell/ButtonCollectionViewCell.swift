//
//  ButtonCollectionViewCell.swift
//  file
//
//  Created by 翟泉 on 2016/10/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


class ButtonCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var buttonWidth: CGFloat = 70
    
    var rightButtons = [UIButton]() {
        didSet {
            for button in oldValue {
                button.removeFromSuperview()
            }
            for (idx, button )in rightButtons.enumerated() {
                addSubview(button)
                button.snp.makeConstraints({ (make) in
                    make.right.equalTo(CGFloat(idx) * buttonWidth)
                    make.top.equalTo(0)
                    make.bottom.equalTo(0)
                    make.width.equalTo(buttonWidth)
                })
            }
            initSubViews()
            rightView.snp.updateConstraints { (make) in
                make.width.equalTo(buttonWidth * CGFloat(rightButtons.count))
            }
        }
    }
    
    func hideButtons(animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _ = gestureRecognizer as? UIPanGestureRecognizer else {
            scrollView.isUserInteractionEnabled = false
            return false
        }
        /*
        let translation = panGesture.translation(in: scrollView)
        if translation.x == translation.y && translation.x == 0 {
            scrollView.isUserInteractionEnabled = false
        }
        else {
            scrollView.isUserInteractionEnabled = true
        }*/
        scrollView.isUserInteractionEnabled = true
        return false
    }
    func pan() {
        
    }
    
    private var scrollView: UIScrollView!
    private var rightView: UIView!
    
    private func initSubViews() {
        guard scrollView == nil else {
            return
        }
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ButtonCollectionViewCell.pan))
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        pan.delegate = self
        scrollView.addGestureRecognizer(pan)
        scrollView.addGestureRecognizer(tap)
        
        rightView = UIView()
        
        contentView.backgroundColor = backgroundColor
        
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(rightView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height)
        }
        rightView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.right)
            make.top.equalTo(scrollView)
            make.width.equalTo(0)
            make.height.equalTo(scrollView.snp.height)
        }
        scrollView.snp.makeConstraints { (make) in
            make.right.equalTo(rightView.snp.right)
        }
    }
    
}
