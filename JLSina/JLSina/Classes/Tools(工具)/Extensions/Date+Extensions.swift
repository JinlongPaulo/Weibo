//
//  Date+Extensions.swift
//  JLSina
//
//  Created by 盘赢 on 2017/12/19.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation

// 日期格式化器 - 不要频繁的释放和创建，会影响性能
private let dateFormatter = DateFormatter()

extension Date {
    
    
    /// 计算当前系统时间偏差，detal 秒数的日期字符串
    /// 在Swift中，如果要定义结构体 '类' 函数，使用 static 修饰 -> 静态函数
    static func cz_dateString(delta: TimeInterval) -> String {
        let date = Date(timeIntervalSinceNow: delta)
        //指定日期格式
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
}
