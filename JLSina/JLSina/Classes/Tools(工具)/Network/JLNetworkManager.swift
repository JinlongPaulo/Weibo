//
//  JLNetworkManager.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/6.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit
import AFNetworking
//网络管理工具
class JLNetworkManager: AFHTTPSessionManager {

    //静态区/常量/闭包 (单例)
    //在第一次访问时执行闭包，并且将结果保存在 shared 常量中
    static let shared = JLNetworkManager()
    
    
}
