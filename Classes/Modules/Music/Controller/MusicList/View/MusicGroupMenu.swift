//
//  MusicGroupMenu.swift
//  file
//
//  Created by 翟泉 on 2016/10/21.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicGroupMenu: Menu, MenuDelegate {
    
    var selectedGroupBlock: ( (_ group: MusicGroup) -> Void )?
    
    init(selectedGroupBlock: @escaping (_ group: MusicGroup) -> Void) {
        super.init()
        
        self.selectedGroupBlock = selectedGroupBlock
        
        delegate = self
        
        navigationBarOffset = 64
        
        DispatchQueue.global().async { [weak self] in
            let names = MusicGroup.groupNames()
            var items = [MenuItem]()
            for name in names {
                let button = UIButton(type: .system)
                button.setTitle("删除", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.backgroundColor = ColorRGB(253, 85, 98)
                
                let item = MenuItem()
                item.title = name
                item.rightButtons = [button]
                items.append(item)
            }
            
            let newItem = MenuItem()
            newItem.title = "创建分组"
            newItem.textColor = UIColor.white
            newItem.backgroundColor = ColorRGB(61, 168, 68)
            newItem.isHiddenSeparatorView = true
            
            items.append(newItem)
            DispatchQueue.main.async {
                self?.items = items
            }
        }
        
    }
    
    
    
    // MARK: - MenuDelegate
    func menu(_ menu: Menu, didSelectRowAt index: Int) {
        if index == menu.items.count - 1 {
            TextFieldAlertView.show(title: "创建播放列表", block: { (name) in
                print(name)
                
                DispatchQueue.global().async {
                    if MusicGroup.create(name: name) != nil {
                        DispatchQueue.main.async {
                            let button = UIButton(type: .system)
                            button.setTitle("删除", for: .normal)
                            button.setTitleColor(UIColor.white, for: .normal)
                            button.backgroundColor = ColorRGB(253, 85, 98)
                            
                            let item = MenuItem()
                            item.title = name
                            item.rightButtons = [button]
                            menu.insertItem(item, at: menu.items.count-1)
                        }
                    }
                }
            })
        }
        else {
            let name = items[index].title!
            let group = MusicGroup(name: name)
            selectedGroupBlock?(group)
            menu.close()
        }
    }
    
    func menu(_ menu: Menu, itemIndex: Int, onClickRightButtonAt buttonIndex: Int) {
        print(menu.items[itemIndex].title!)
        
        DispatchQueue.global().async {
            if MusicGroup.delete(name: menu.items[itemIndex].title!) {
                DispatchQueue.main.async {
                    menu.removeItem(idx: itemIndex)
                }
            }
            else {
                debugPrint("删除表失败")
            }
        }
    }
    
    
}




