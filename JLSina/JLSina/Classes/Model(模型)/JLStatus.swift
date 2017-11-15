//
//  JLStatus.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/7.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit
import YYModel
//微博数据模型
@objcMembers
class JLStatus: NSObject {
    //Int类型，在64位的机器是64位，在32位机器就是32位
    //如果不写Int64 在iPad2/iphone 5/5C/4s/4都无法正常运行
    //微博ID
    var id: Int64 = 0
    //微博信息内容
    var text: String?
    
    //转发数
    var reposts_count: Int = 0
    //评论数
    var comments_count: Int = 0
    //赞数
    var attitudes_count: Int = 0
    
    //微博用户 - 注意和服务器返回的 key 要一致
    var user: JLUser?
    

    //重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
}
