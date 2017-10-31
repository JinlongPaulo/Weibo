//
//  Bundle+Extensions.swift
//  JLSina
//
//  Created by 盘赢 on 2017/10/31.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation

extension Bundle {
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
