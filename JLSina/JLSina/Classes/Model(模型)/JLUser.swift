//
//  JLUser.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/14.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//微博用户模型
@objcMembers
class JLUser: NSObject {

    //基本数据类型 & private 不能使用KVC设置
    //用户UID
    var id: Int64 = 0
    //用户昵称
    var screen_name: String?
    //用户头像地址（中图），50×50像素
    var profile_image_url: String?
    //认证类型。-1：没有认证 0：认证用户，2,3,5企业认真 ， 220：达人
    var verified_type: Int = 0
    //会员等级
    var mbrank: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
