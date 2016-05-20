//
//  TextFieldAlertView.swift
//  file
//
//  Created by 翟泉 on 16/5/12.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import SnapKit

final class TextFieldAlertView: UIView {

    var textField: UITextField!
    var titleLabel: UILabel!
    var cancelButton : UIButton!
    var confirmButton: UIButton!
    var backgroundView: UIView!
    
    
    var confirmBlock: ((text: String)-> Void)?
    
    private init() {
        super.init(frame: CGRectZero)
        layer.masksToBounds = true
        layer.cornerRadius = 8
        backgroundColor = UIColor.whiteColor()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextFieldAlertView.keyBoardWillShow), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextFieldAlertView.keyBoardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    class func show(title: String, confirmBlock: ((text: String)-> Void)?) -> TextFieldAlertView {
        let alertView = TextFieldAlertView()
        alertView.setupUI()
        alertView.titleLabel.text = title
        alertView.confirmBlock = confirmBlock
        alertView.show()
        return alertView
    }
    
    func show() {
        textField.becomeFirstResponder()
    }
    
    func hide() {
        textField.resignFirstResponder()
        UIView.animateWithDuration(0.1, animations: { 
            self.backgroundView.alpha = 0
            self.transform = CGAffineTransformMakeScale(0.2, 0.2)
        }) { (finished) in
            self.backgroundView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    func confirm() {
        guard let text = textField.text else {
            return
        }
        hide()
        guard confirmBlock != nil else {
            return
        }
        confirmBlock!(text: text)
    }
    
    func keyBoardWillShow(note: NSNotification) {
        guard let keyboardFrameObject = note.userInfo![UIKeyboardFrameEndUserInfoKey] else {
            return
        }
        guard let keyboardFrameValue = keyboardFrameObject as? NSValue else {
            return
        }
        let keyboardFrame = keyboardFrameValue.CGRectValue()
        
        guard let animationDurationObject = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] else {
            return
        }
        guard let animationDurationNumber = animationDurationObject as? NSNumber else {
            return
        }
        let animationDuration = animationDurationNumber.doubleValue
        
        guard let animationCurveObject = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] else {
            return
        }
        guard let animationCurveNumber = animationCurveObject as? NSNumber else {
            return
        }
        let animationCurve = UInt(animationCurveNumber.integerValue)
        let animationOptions = UIViewAnimationOptions(rawValue: animationCurve)
        
        let offset = SSize.height - keyboardFrame.height - height - y - 20
        if animationDuration > 0 {
            UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: { 
                self.transform = CGAffineTransformTranslate(self.transform, 0, offset)
            }, completion: nil)
        }
        else {
            self.transform = CGAffineTransformTranslate(self.transform, 0, offset)
        }
    }
    
    func keyBoardWillHide(note: NSNotification) {
        
    }
    
    
    // MARK: Private
    
    private func setupUI() {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            return
        }
        guard let rootView = appDelegate.window?.rootViewController?.view else {
            return
        }
        rootView.addSubview(self)
        
        backgroundView = UIView()//UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        backgroundView.backgroundColor = ColorRGBA(0, g: 0, b: 0, a: 0.4)
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(TextFieldAlertView.hide))
        backgroundView.addGestureRecognizer(tapBackground)
        rootView.insertSubview(backgroundView, belowSubview: self)
        
        
        titleLabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.Center
        addSubview(titleLabel)
        
        textField = UITextField()
        textField.borderStyle = UITextBorderStyle.RoundedRect
        addSubview(textField)
        
        cancelButton = UIButton(type: UIButtonType.System)
        cancelButton .setTitle("取消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: #selector(TextFieldAlertView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(cancelButton)
        
        confirmButton = UIButton(type: UIButtonType.System)
        confirmButton.setTitle("确定", forState: UIControlState.Normal)
        confirmButton.addTarget(self, action: #selector(TextFieldAlertView.confirm), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(confirmButton)
        
        
        
        backgroundView.snp_makeConstraints { (make) in
            make.edges.equalTo(rootView)
        }
        
        self.snp_makeConstraints { (make) in
            make.width.equalTo(rootView).multipliedBy(0.7)
            make.bottom.equalTo(confirmButton)
            make.centerX.equalTo(rootView)
//            make.centerY.equalTo(rootView)
            make.top.equalTo(150)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(20)
            make.top.equalTo(20)
            make.centerX.equalTo(self)
        }
        
        textField.snp_makeConstraints { (make) in
            make.width.equalTo(self).multipliedBy(0.8)
            make.centerX.equalTo(self)
            make.height.equalTo(30)
            make.top.equalTo(titleLabel.snp_bottom).offset(20)
        }
        
        cancelButton.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(textField.snp_bottom).offset(10)
            make.width.equalTo(self).multipliedBy(0.5)
            make.height.equalTo(40)
        }
        
        confirmButton.snp_makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.equalTo(textField.snp_bottom).offset(10)
            make.width.equalTo(self).multipliedBy(0.5)
            make.height.equalTo(40)
        }
    }
    
}
