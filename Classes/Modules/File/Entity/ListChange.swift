//
//  ListChange.swift
//  file
//
//  Created by 翟泉 on 2017/2/23.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import Foundation

// 移动位置的当前和目标索引
struct ListMoveIndex: Equatable {
    let index: Int
    let newIndex: Int
    var value: (Int, Int) {
        return (index, newIndex)
    }
    
}

// 变更类型
enum ListChangeType {
    case insert
    case delete
    case reload
    case move
    case reloadAll
    case reloadVisible
}

struct ListChange {
    
    /// Value
    var indexs: [Int] {
        return _indexs ?? []
    }
    var moveIndexs: [ListMoveIndex] {
        return _moveIndex ?? []
    }
    let type: ListChangeType
    
    /// Init
    
    /// 插入
    static func insert(indexs: [Int]) -> ListChange {
        return ListChange(indexs: indexs, moveIndexs: nil, type: .insert)
    }
    /// 删除
    static func delete(indexs: [Int]) -> ListChange {
        return ListChange(indexs: indexs, moveIndexs: nil, type: .delete)
    }
    /// 刷新
    static func reload(indexs: [Int]) -> ListChange {
        return ListChange(indexs: indexs, moveIndexs: nil, type: .reload)
    }
    /// 移动
    static func move(moveIndexs: [(Int, Int)]) -> ListChange {
        var _moveIndexs = [ListMoveIndex]()
        for (a, b) in moveIndexs {
            _moveIndexs.append(ListMoveIndex(index: a, newIndex: b))
        }
        return ListChange(indexs: nil, moveIndexs: _moveIndexs, type: .reload)
    }
    /// 刷新所有
    static let reloadAll: ListChange = ListChange(indexs: nil, moveIndexs: nil, type: .reloadAll)
    /// 刷新可见
    static let reloadVisible: ListChange = ListChange(indexs: nil, moveIndexs: nil, type: .reloadVisible)
    
    private let _indexs: [Int]?
    private let _moveIndex: [ListMoveIndex]?
    
    private init(indexs: [Int]?, moveIndexs: [ListMoveIndex]?, type: ListChangeType) {
        _indexs = indexs
        _moveIndex = moveIndexs
        self.type = type
    }
}

extension ListChange: Equatable {
    
}

func ==(lhs: ListMoveIndex, rhs: ListMoveIndex) -> Bool {
    return lhs.index == rhs.index && lhs.newIndex == rhs.newIndex
}

func ==(lhs: ListChange, rhs: ListChange) -> Bool {
    return lhs.type == rhs.type && lhs.indexs == rhs.indexs && lhs.moveIndexs == rhs.moveIndexs
}


