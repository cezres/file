//
//  ButtonTableViewCell.swift
//  file
//
//  Created by 翟泉 on 2016/10/18.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: NSObjectProtocol {
    func buttonCell(_ buttonCell: ButtonTableViewCell, onClickRightButtonAt index: Int)
}

class ButtonTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    func onClickButton(_ button: UIButton) {
        delegate?.buttonCell(self, onClickRightButtonAt: button.tag)
    }
    
    func setRightButtons(_ buttons: [UIButton], withButtonWidth width: CGFloat) {
        initSubViews()
        
        for subview in rightView.subviews {
            subview.removeFromSuperview()
        }
        
        for (idx, button)in buttons.enumerated() {
            button.tag = idx
            button.addTarget(self, action: #selector(ButtonTableViewCell.onClickButton(_:)), for: .touchUpInside)
            rightView.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.right.equalTo(CGFloat(idx) * width)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                make.width.equalTo(width)
            })
        }
        
        rightView.snp.updateConstraints { (make) in
            make.width.equalTo(width * CGFloat(buttons.count))
        }
    }
    
    
    func showButtons(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.rightView.transform.tx = -self.rightView.width
            }
        }
        else {
            rightView.transform.tx = -rightView.width
        }
    }
    func hideButtons(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.rightView.transform.tx = 0
            }
        }
        else {
            rightView.transform.tx = 0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isBeganPanGestureRecognizer {
            hideButtons(animated: false)
        }
    }
    
    var isBeganPanGestureRecognizer = false
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return super.gestureRecognizerShouldBegin(gestureRecognizer) }
        let translation = pan.translation(in: self)
        isBeganPanGestureRecognizer = fabs(translation.x) > fabs(translation.y)
        return isBeganPanGestureRecognizer
    }
    
    private var oldtx: CGFloat = 0
    
    func handlePan(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            addSubview(rightView)
            oldtx = rightView.transform.tx
        }
        
        let translation = pan.translation(in: self)
        
        var offset = translation.x + oldtx
        if offset > 0 {
            offset = 0
        }
        else if offset < -rightView.width {
            offset = -rightView.width
        }
        rightView.transform.tx = offset
        
        guard pan.state == .ended || pan.state == .cancelled else {
            return
        }
        if -offset > rightView.width/2 {
            showButtons(animated: true)
        }
        else {
            hideButtons(animated: true)
        }
        isBeganPanGestureRecognizer = false
    }
    
    
    private var rightView: UIView!
    
    private func initSubViews() {
        guard rightView == nil else {
            return
        }
        rightView = UIView()
        addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.right)
            make.top.equalTo(snp.top)
            make.width.equalTo(0)
            make.height.equalTo(snp.height)
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ButtonTableViewCell.handlePan(pan:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    

}
