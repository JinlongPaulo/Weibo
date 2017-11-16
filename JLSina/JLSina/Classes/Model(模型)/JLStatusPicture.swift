//
//  JLStatusPicture.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/16.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//微博配图模型
@objcMembers
class JLStatusPicture: NSObject {

    //缩略图地址
    var thumbnail_pic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
