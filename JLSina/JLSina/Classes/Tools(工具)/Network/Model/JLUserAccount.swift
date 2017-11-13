//
//  JLUserAccount.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/10.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

private let accountFile: NSString = "useraccount.json"

//用户账户信息
@objcMembers
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
    
    //用户昵称
    var screen_name:NSString?
    //用户头像地址（大图），180×180像素
    var avatar_large:NSString?
    
    
    override init() {
        super.init()
        
        //从磁盘加载保存的文件 ->字典
        //1>加载磁盘文件到二进制，如果失败直接返回
        guard let path = accountFile.cz_appendDocumentDir() ,
              let data = NSData(contentsOfFile: path) ,
              let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject]
        else {
                return
        }
        
        //2>使用字典设置属性值
//        yy_modelSet(with: dict ?? [:])
        
        print("从沙盒加载信息\(self)")
        //3.判断tiken是否过期
        //测试过期日期 - 在开发中，每一个分支都需要测试
//        expiresDate = Date(timeIntervalSinceNow: -3600 * 24)
//        print(expiresDate)
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("账户过期")
            //清空token
            access_token = nil
            uid = nil
            
            //删除账户文件
            try? FileManager.default.removeItem(atPath: path)
            
        }
        
    }
    
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
        //1.模型转字典
        var dict = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        
        //需要删除expires_in 值
        dict.removeValue(forKey: "expires_in")
        //2.字典序列化
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) ,
         let filePath = accountFile.cz_appendDocumentDir()
        else {
            return
        }
        
        //3.写入磁盘
       (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功\(filePath)")
        
    }
}
