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
    //since_id:若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    //max_id:若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    // completion：完成回调（list：微博字典数组/是否成功）
    func statusList(since_id: Int64 = 0 ,max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]? , _ isSuccess: Bool)->()) {
        
        //用网络工具加载微博数据
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json";

        //Swift 中 Int可以转换成AnyObject / Int64不行
        let params = ["since_id": "\(since_id)",
                     "max_id":"\(max_id)"]
        
        tokenRequest(URLString: urlStr, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            //从json中获取statuses字典数组
            //如果 as？失败，result = nil
            let result = json?["statuses"] as? [[String: AnyObject]]
            
            completion(result , isSuccess)
        }
    }
}
