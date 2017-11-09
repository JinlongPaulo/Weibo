//
//  JLStatusListViewModel.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/7.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation

//微博数据列表视图模型
/*
 父类的选择
 
 - 如果类需要使用 ‘KVC’ 或者字典转模型框架设置对象值，类就需要继承自 NSObject
 - 如果类只是包装一些代码逻辑（写了一些函数），可以不用任何父类，好处：轻量级
 - 提示：如果用OC写，一律都继承自 NSObject 即可
 
 使命：负责微博的数据处理
 1,字典转模型
 2,下拉/上拉刷新数据处理
*/

//上拉刷新最大尝试次数
private let maxPullipTryTime = 3
class JLStatusListViewModel {
    //微博模型数组懒加载
    lazy var statusList = [JLStatus]()
    
    //上拉刷新错误次数
    private var pullupErrorTimes = 0
    //加载微博列表
    //pullup:是否上拉标记
    //completion：网络请求是否成功
    //hasMorePullup:是否刷新表格
    
    func loadStatus(pullup:Bool , completion: @escaping (_ isSuccess: Bool , _ shouldRefresh: Bool)->()) {
        
        
        //判断是否是上拉刷新，同时检查刷新错误
        if pullup && pullupErrorTimes > maxPullipTryTime {
            completion(true , false)
            return
        }
        
        //since_id 取出数组中第一天微博的id
        let since_id = pullup ? 0 : (statusList.first?.id ?? 0)
        
        //上拉刷新,取出数组的最后的一条id
        let max_id = !pullup ? 0 : (statusList.last?.id ?? 0)
        
        
        JLNetworkManager.shared.statusList(since_id: since_id,max_id: 0) { (list, isSuccess) in
            
//            1,字典转模型
//            guard let array = NSArray.yy_modelArray(with: JLStatus.self, json: list ?? []) as? [JLStatus] else {
//
//                completion(isSuccess)
//
//                return
//            }
            

            //2,拼接数据
//            self.statusList += array
            if pullup {
                self.statusList.removeAll()
            }
            
            for dict  in list ?? [] {
                let dic: NSDictionary = dict as NSDictionary
                let model = JLStatus()
//                model.setValuesForKeys(dic as! [String : Any])
                model.id = dic.object(forKey: "id") as! Int64
                model.text = dic.object(forKey: "text") as? String
                self.statusList.append(model)
                //                print("字数是\(String(describing: model.text))字典的值\(String(describing: dic["text"]))数组是\(String(describing: list?.count.description))")
            }
            
            //判断上拉刷新的数据量
            if pullup && self.statusList.count == 0 {
                self.pullupErrorTimes += 1
                
                completion(isSuccess , false)
            } else {
                
                //3,完成回调
                completion(isSuccess , true)
            }
        }
    }
}
