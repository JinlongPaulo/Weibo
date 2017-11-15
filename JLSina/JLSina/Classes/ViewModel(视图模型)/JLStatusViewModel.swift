//
//  JLStatusViewModel.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/15.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation

//单条微博的视图模型
/**
 如果没有任何父类，如果希望在开发时调试，输出调试信息
 1，遵守 CustomStringConvertible
 2，实现 description 计算型属性
 
 关于表格的性能优化
 - 尽量少计算，所有的素材提前计算好
 - 控件上不要设置圆角半径，所有图像渲染的属性，都要注意
 - 不要动态创建空间，所有需要的控件，都要提前创建好，在显示的时候，根据数据隐藏，显示
 (用内存换取CPU)
 - cell中控件的层次越少越好，数量越少越好
 - 要测量，不要猜测！
*/
class JLStatusViewModel: CustomStringConvertible {

    //微博模型
    var status: JLStatus
    
    //会员图标
    var memberIcon: UIImage?
    
    //认证类型。-1：没有认证 0：认证用户，2,3,5企业认真 ， 220：达人
    var vipIcon: UIImage?
    
    
    //构造函数
    init(model: JLStatus) {
        self.status = model
        //common_icon_membership_level1
        //会员等级0-6
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            
            memberIcon = UIImage.init(named: imageName)
        }
        
        //认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage.init(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage.init(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage.init(named: "avatar_grassroot")
        default:
            break
        }
    }
    
    var description: String {
        return status.description
    }
}
