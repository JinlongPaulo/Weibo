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
    //微博视图模型数组懒加载
    lazy var statusList = [JLStatusViewModel]()
    
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
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        
        //上拉刷新,取出数组的最后的一条id
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        
        JLNetworkManager.shared.statusList(since_id: since_id,max_id: max_id) { (list, isSuccess) in
            
            //0,判断网络请求是否成功
            if !isSuccess {
                //直接回调返回
                completion(false , false)
                return
            }
            
//            1,字典转模型(所有的第三方都支持嵌套的字典转模型)
            //1>定义结果可变数组
            var array = [JLStatusViewModel]()
            //2>遍历服务器返回的字典数组,字典转模型
            for dict in list ?? [] {
                //a)创建微博模型,
                let status = JLStatus()
                
                status.yy_modelSet(with: dict)
                
                let viewModel = JLStatusViewModel(model: status)
                
                array.append(viewModel)
            }

            print("刷新到\(array.count)条数据,\(array)")
            //2,拼接数据

            if pullup {
                self.statusList += array
            } else {
                self.statusList = array + self.statusList
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
