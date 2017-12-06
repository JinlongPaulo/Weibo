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
    
    //微博创建时间字符串
    var created_at: String?
    
    //微博来源 - 发布微博使用的客户端
    var source: String?
    
    //转发数
    var reposts_count: Int = 0
    //评论数
    var comments_count: Int = 0
    //赞数
    var attitudes_count: Int = 0
    
    //微博用户 - 注意和服务器返回的 key 要一致
    var user: JLUser?
    
    //微博配图模型数组
    var pic_urls: [JLStatusPicture]?
    
    //被转发的原创微博
    var retweeted_status: JLStatus?
    

    //重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
    //类函数 ->告诉第三方框架YYModel，如果遇到数组类型的属性，数组中存放的对象是什么类？
    //NSArray 中 保存对象的类型通常是 ‘id‘ 类型
    //OC中的泛型是 Swift 推出后，苹果为了兼容给 OC 增加的，
    //从运行时角度，仍然不知道数组中应该存放什么类型的对象
    class func modelContainerPropertyGenericClass() -> [String: AnyClass]{
        return ["pic_urls": JLStatusPicture.self]
    }
    
}
