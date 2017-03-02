//
//  ASImageView.swift
//  file
//
//  Created by 翟泉 on 2017/2/22.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ASImageView: UIView {
    
    var image: UIImage? {
        get {
            return imageNode.image
        }
        set {
            imageNode.image = newValue
        }
    }
    
    lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        self.addSubnode(node)
        return node
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageNode.frame = bounds
    }
    
    override var contentMode: UIViewContentMode {
        didSet {
            imageNode.contentMode = contentMode
        }
    }
    
    override var isOpaque: Bool {
        didSet {
            imageNode.isOpaque = isOpaque
        }
    }
    
    override var clipsToBounds: Bool {
        didSet {
            imageNode.clipsToBounds = clipsToBounds
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
