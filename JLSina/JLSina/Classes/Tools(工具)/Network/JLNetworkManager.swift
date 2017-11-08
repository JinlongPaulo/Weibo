//
//  JLNetworkManager.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/6.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit
import AFNetworking

//swift的枚举支持任意数据类型
//switch / enum 在OC中都只是支持整数
enum JLHttpMethod {
    case GET
    case POST
}
//网络管理工具
class JLNetworkManager: AFHTTPSessionManager {

    //静态区/常量/闭包 (单例)
    //在第一次访问时执行闭包，并且将结果保存在 shared 常量中
    static let shared = JLNetworkManager()
    
    //访问令牌，所有网络请求，都基于此令牌，登录除外
    //访问令牌有时限，默认用户是三天
    //模拟token过期，服务器返回的状态码是403
    var accessToken: String? = "2.00oHIRKGzx9_IBe7c088d1820xzC9i"
    
    //专门负责拼接token的网络请求方法
    func tokenRequest(method: JLHttpMethod = .GET, URLString: String, parameters: [String:AnyObject]?, completion: @escaping (_ json: AnyObject?,_ isSuccess: Bool) ->()) {
        
        //处理token字典
        //0>判断token是否为nil，直接返回
        
        guard let token = accessToken else {
            //FIXME: 发送通知，提示用户登录
            print("没有token，需要登录")
            
            completion(nil , false)
            return
        }
        //1>判断参数字典是否存在，如果为nil，应该新建一个字典
        var parameters = parameters
        if parameters == nil {
            //实例化字典
            parameters = [String: AnyObject]()
        }
        //2>设置参数字典,代码在此处，字典一定有值
         parameters!["access_token"] = token as AnyObject?
        //调用request发起真正的网络请求方法
        request(URLString: URLString, parameters: parameters, completion: completion)
    }
    
    //使用一个函数，封装AFN的 get 和 post 请求
    /// - parameter method:     GET /POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter completion: 回调json、是否成功
    func request(method: JLHttpMethod = .GET, URLString: String, parameters: [String:AnyObject]?, completion: @escaping (_ json: AnyObject?,_ isSuccess: Bool) ->()) {
        
        //成功回调
        let success = {(task: URLSessionDataTask, json: Any?) ->() in
            completion(json as AnyObject, true)
        }
        //失败回调
        let failure = {(task: URLSessionDataTask?, error: Error) ->() in
            
            //针对 403 处理token 过期
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                print("token过期")
                //FIXME: 发送通知(本方法不知道被谁调用，谁接收到通知，谁处理)
                
            }
            print("网络请求错误\(error)")
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
