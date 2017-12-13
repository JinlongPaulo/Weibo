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
            "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(URLString: urlStr, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            //从json中获取statuses字典数组
            //如果 as？失败，result = nil
            //服务器返回的字典数组，就是按照时间的倒序排序的
            let result = json?["statuses"] as? [[String: AnyObject]]
            
            completion(result , isSuccess)
        }
    }
    
    
    //返回微博的未读数量 - 定时刷。不需要提示是否失败
    func unreadCount(completion: @escaping (_ count: Int)->()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let params = ["uid": uid]
        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            
            let dict = json as? [String: AnyObject]
            
            let count = dict?["status"] as? Int
            
            completion(count ?? 0)
        }
        
        
    }
}

//MARK: - 发布微博
//FIXME: 新浪微博接口拼接问题，老接口换了
extension JLNetworkManager {
    ///发布微博
    ///
    /// - Parameters:
    ///   - text: 要发布的文本
    ///   - image: 要上传的图像 ，可以为nil，nil = 发布纯文本微博
    ///   - completion: 完成回调
    func postStatus(text: String , image: UIImage? , completion:@escaping (_ result: [String:AnyObject]? , _ isSuccess: Bool)->()) -> () {
        //1,url
        let urlString = "https://api.weibo.com/2/statuses/share.json"
        
        //2,参数字典
        //FIXME: - 用户分享到微博的文本内容，必须做URLencode，内容不超过140个汉字，文本中不能包含“#话题词#”，同时文本中必须包含至少一个第三方分享到微博的网页URL，且该URL只能是该第三方（调用方）绑定域下的URL链接，绑定域在“我的应用 － 应用信息 － 基本应用信息编辑 － 安全域名”里设置。
        let params = ["status":text]
        
        //如果图像不为空，需要设置name和data
        var name: String?
        var data: Data?
        
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        //3,发起网络请求
        tokenRequest(method: .POST, URLString: urlString, parameters: params as [String : AnyObject], name: name, data: data) { (json, isSuccess) in
            completion(json as? [String: AnyObject] , isSuccess)
        }
        
    }
}


//MARK: - 用户信息
extension JLNetworkManager {
    
    //加载当前用户信息，用户登录后立即执行
    func loadUserInfo(completion: @escaping (_ dict: [String: AnyObject])->()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        let urlStr = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid":uid]
        
        tokenRequest(URLString: urlStr, parameters: params as [String : AnyObject]) { (json, isSuccess) in
    
            completion(json as? [String: AnyObject] ?? [:])
        }
    }
}


//MARK: - OAuth相关方法
extension JLNetworkManager {
    //加载AccessToken
    //提问：网络请求异步到底应该返回什么 - 需要什么，返回什么
    //code:授权码 ，completion-完成回调，是否成功
    func loadAccessToken(code: String , completion: @escaping (_ isSuccess: Bool)->()){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id":WBAppKey ,
                      "client_secret":AppSecret ,
                      "grant_type":"authorization_code" ,
                      "code":code ,
                      "redirect_uri":WBRedirectURI]
        
        //发起网络请求
        request(method: .POST, URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            print(json as Any)
            
            //如果请求失败，对用户账户数据不会有任何影响
            //直接用字典设置userAccount的属性
            self.userAccount.yy_modelSet(with: (json as? [String: AnyObject]) ?? [:])
            
            //加载当前用户信息
            self.loadUserInfo(completion: { (dict) in
                //使用用户信息字典，设置用户账户信息，昵称和头像地址
                self.userAccount.yy_modelSet(with: dict)
                //保存模型
                self.userAccount.saveAccount()
                print(self.userAccount)
                //用户信息加载完成，再完成回调
                completion(isSuccess)
            })
      
        }
    }
}
