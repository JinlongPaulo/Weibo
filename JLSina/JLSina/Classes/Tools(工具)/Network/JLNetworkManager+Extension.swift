//
//  JLNetworkManager+Extension.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/7.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation

//MARK: - 封装新浪微博的网络请求方法
extension JLNetworkManager {
    
    
    //加载微博数据字典数组
    // completion：完成回调（list：微博字典数组/是否成功）
    func statusList(completion: @escaping (_ list: [[String: AnyObject]]? , _ isSuccess: Bool)->()) {
        
        //用网络工具加载微博数据
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json";

        tokenRequest(URLString: urlStr, parameters: nil) { (json, isSuccess) in
            //从json中获取statuses字典数组
            //如果 as？失败，result = nil
            let result = json?["statuses"] as? [[String: AnyObject]]
            
            completion(result , isSuccess)
        }
    }
}
