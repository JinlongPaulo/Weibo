
//
//  WeiboCommon.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/9.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation

//https://api.weibo.com/oauth2/authorize?client_id=2607327855&redirect_uri=https://www.baidu.com

//MARK: - 应用程序信息
//应用程序id
let WBAppKey = "2607327855"
//应用程序加密信息(开发者可以申请修改)
let AppSecret = "e2a3237ddee431b89853b50a46c87de8"
//回调地址 - 登录完成调转的URL，参数以 get 形式拼接
let WBRedirectURI = "https://www.baidu.com"

//MARK: 全局通知定义
//用户需要登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"

//用户登录成功通知
let WBUserLoginSuccessedNotification = "WBUserLoginSuccessedNotification"


