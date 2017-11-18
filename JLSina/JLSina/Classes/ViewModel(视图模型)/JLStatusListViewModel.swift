//
//  JLStatusListViewModel.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/7.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation
import SDWebImage
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
                
                self.cacheSingleImage(list: array , finished: completion)
                //3,真正有数据的回调
//                completion(isSuccess , true)
            }
        }
    }
    
    //缓存本次下载微博数据数组中的单张图像
    //应该缓存完单张图像，并且修改过配图大小之后，再回调，才能够保证表格等比例显示单张图像
    //list：本次下载的视图模型数组
    private func cacheSingleImage(list: [JLStatusViewModel] , finished: @escaping (_ isSuccess: Bool , _ shouldRefresh: Bool)->()) {
        
        //调度组
        let group = DispatchGroup()
        
        //记录数据长度
        var length = 0
        
        //遍历数组，查找微博数据中，有单张图像的进行缓存
        for vm in list {
            //1> 判断图像数量
            if vm.picURLs?.count != 1 {
                continue
            }
            
            //2>代码执行到此，数组中有且仅有一张图片，获取图像模型
            guard let pic = vm.picURLs?[0].thumbnail_pic ,
                  let url = URL.init(string: pic) else {
                return
            }
            
//            print("要缓存的url是\(pic)")
            
            //3>下载图像
            //downloadImage 是SDWebImage的核心方法
            //图像下载完成之后，会自动保存在沙盒中，文件路径是 url 的MD5
            //如果沙盒中已经存在缓存的图像，后续使用sd通过url加载图像，都会加载本地沙盒的图像
            //不会发起网络请求,同时回调方法，同样会调用
            //方法还是同样的方法，调用还是同样的调用，不过内部不会再次发起网络请求
            //注意点：如果要缓存图像累计很大，要找后台要接口
            
            
            //A>入组
            group.enter()
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _) in
                //将图像转换成二进制数据
                if let image = image ,
                    let data = UIImagePNGRepresentation(image) {
                    
                    //NSData是length属性
                    length += data.count
                    
                    //图像缓存成功，更新配图视图大小
                    vm.updateSingleImageSize(image: image)
                }
                
                print("缓存的图像是\(image)长度\(length)")
                
                //B>出组 - 放在回调的最后一句
                group.leave()
            })
            
            
        }
        
        //C>监听调度组情况
        group.notify(queue: DispatchQueue.main) {
            print("图像缓存完成\(length / 1024)K")
            
            //执行闭包回调
            finished(true, true)
        }
    }
}
