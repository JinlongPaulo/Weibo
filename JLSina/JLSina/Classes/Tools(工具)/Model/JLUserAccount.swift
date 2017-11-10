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
    var access_token: String? //= "2.00oHIRKGFFF9qCe43302bd7a0SbDlG"
    //用户代号
    var uid: String?
    
    //access_token的生命周期，单位是秒数。
    //开发者5年 每次登录之后，都是5年
    //使用者3天,会从第一次登录递减
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    //过期日期
    var expiresDate: Date?
    
    
    override var description: String {
        return yy_modelDescription()
    }
    
    /*
     1.偏好设置(存小的) - Xcode 8.beta 无效
     2.沙盒-归档/plist/json
     3.数据库(FMDB/CoreData)
     4.钥匙串(小/自动加密-需要使用框架SSKeychina)
     */
    func saveAccount() {
        
    }
}
