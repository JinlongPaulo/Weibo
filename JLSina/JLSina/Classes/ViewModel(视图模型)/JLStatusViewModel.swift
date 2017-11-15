//
//  JLStatusViewModel.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/15.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation

//单条微博的视图模型
class JLStatusViewModel {
    
    //微博模型
    var status: JLStatus
    
    //构造函数
    init(model: JLStatus) {
        self.status = model
    }
    
}
