//
//  FileTableViewCell.swift
//  file
//
//  Created by 翟泉 on 2016/7/12.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class FileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFileEntity(file: FileEntity) {
        textLabel?.text = file.name
    }

}
