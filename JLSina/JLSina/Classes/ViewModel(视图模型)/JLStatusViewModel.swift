//
//  JLStatusViewModel.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/15.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation

//单条微博的视图模型
/**
 如果没有任何父类，如果希望在开发时调试，输出调试信息
 1，遵守 CustomStringConvertible
 2，实现 description 计算型属性
*/
class JLStatusViewModel: CustomStringConvertible {

    //微博模型
    var status: JLStatus
    
    //构造函数
    init(model: JLStatus) {
        self.status = model
    }
    
    var description: String {
        return status.description
    }
}
