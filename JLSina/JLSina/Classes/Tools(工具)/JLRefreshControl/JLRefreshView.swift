//
//  JLRefreshView.swift
//  刷新控件
//
//  Created by 盘赢 on 2017/11/21.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//刷新视图 - 负责刷新相关的 UI 显示和动画
class JLRefreshView: UIView {

    //提示图片
    @IBOutlet weak var tipIcon: UIImageView!
    
    //提示标签
    @IBOutlet weak var tipLabel: UILabel!
    
    //指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
}
