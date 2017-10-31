//
//  Bundle+Extension.swift
//  007-反射机制
//
//  Created by 盘赢 on 2017/9/28.
//  Copyright © 2017年 yingpan. All rights reserved.
//

import Foundation

extension Bundle {
    
    //计算型属性类似于函数，没有参数，有返回值
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
