//
//  TextFieldAlertView.swift
//  file
//
//  Created by 翟泉 on 2016/10/18.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class TextFieldAlertView: UIView {

    
    var block: ( (_ text: String) -> Void )?
    
    class func show(title: String, block: @escaping (_ text: String) -> Void) {
        guard let window = UIApplication.shared.delegate!.window! else {
            return
        }
        
        let alertView = TextFieldAlertView()
        alertView.titleLabel.text = title
        alertView.block = block
        alertView.textField.becomeFirstResponder()
        
        window.addSubview(alertView.backgroundButton)
        window.addSubview(alertView)
        
        alertView.snp.makeConstraints { (make) in
            make.width.equalTo(260)
            make.centerX.equalTo(window.snp.centerX)
            make.top.equalTo(64 + 150)
            make.bottom.equalTo(alertView.cancelButton.snp.bottom)
        }
        
        alertView.backgroundButton.snp.makeConstraints { (make) in
            make.edges.equalTo(window.snp.edges)
        }
    }
    
    
    init() {
        super.init(frame: CGRect())
        backgroundColor = UIColor.white
        initSubviews()
        
        layer.cornerRadius = 8
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confirm() {
        guard let text = textField.text else { return }
        guard text.lengthOfBytes(using: .utf8) > 0 else { return }
        block?(text)
        cancel()
    }
    
    func cancel() {
        removeFromSuperview()
        backgroundButton.removeFromSuperview()
        textField.resignFirstResponder()
    }
    
    
    var textField = UITextField()
    var titleLabel = UILabel()
    var cancelButton = UIButton(type: UIButtonType.system)
    var confirmButton = UIButton(type: UIButtonType.system)
    var backgroundButton = UIButton(type: UIButtonType.custom)
    
    
    func initSubviews() {
        textField.layer.borderColor = ColorWhite(230).cgColor
        textField.layer.borderWidth = 1
        
        titleLabel.textAlignment = .center
        
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(TextFieldAlertView.cancel), for: .touchUpInside)
        
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.addTarget(self, action: #selector(TextFieldAlertView.confirm), for: .touchUpInside)
        
        backgroundButton.addTarget(self, action: #selector(TextFieldAlertView.cancel), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(cancelButton)
        addSubview(confirmButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(20)
            make.height.equalTo(20)
        }
        textField.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width).multipliedBy(0.8)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.left.equalTo(snp.centerX)
            make.height.equalTo(50)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(snp.centerX)
            make.height.equalTo(50)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }
        
    }
    

}
