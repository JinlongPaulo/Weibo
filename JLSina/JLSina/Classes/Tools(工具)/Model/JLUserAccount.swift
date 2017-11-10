//
//  JLUserAccount.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/10.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit
import YYModel
//用户账户信息
class JLUserAccount: NSObject {

    //访问令牌
    var access_token: String?
    //用户代号
    var uid: String?
    
    //access_token的生命周期，单位是秒数。
    //开发者5年
    //使用者3天
    var expires_in: TimeInterval = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
