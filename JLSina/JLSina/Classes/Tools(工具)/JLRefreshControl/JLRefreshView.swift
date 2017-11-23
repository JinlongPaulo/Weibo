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
    
    //刷新状态
    /*
     iOS 系统中 ，UIView 封装的旋转动画
     - 默认顺时针旋转
     - 就近原则
     - 要想实现同方向旋转，需要调整一个 非常小的数字
     - 如果想实现 360‘ 旋转，需要核心动画 CABaseAnimation
     */
    var refreshState: JLRefreshState = JLRefreshState.Normal {
        didSet {
            switch refreshState {
            case .Normal:
                //恢复状态
                tipIcon.isHidden = false
                indicator.stopAnimating()
                tipLabel.text = "继续使劲拉..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon.transform = CGAffineTransform.identity
                }
            case .Pulling:
                tipLabel.text = "放手就刷新..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 0.001))
                }
            case.WillRefresh:
                tipLabel.text = "正在刷新中..."
                //隐藏提示图标，显示菊花
                tipIcon.isHidden = true
                
                indicator.startAnimating()
                
            }
        }
    }
    

    //提示图片
    @IBOutlet weak var tipIcon: UIImageView!
    
    //提示标签
    @IBOutlet weak var tipLabel: UILabel!
    
    //指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    class func refreshView()-> JLRefreshView {
        let nib = UINib(nibName: "JLMeituanRefreshView", bundle: nil)
        
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! JLRefreshView
        
        
    }
}
