//
//  JLWelcomeView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/13.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//欢迎视图
class JLWelcomeView: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    class func welcomeView()-> JLWelcomeView {
        let nib = UINib(nibName: "JLWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! JLWelcomeView
        
        //从xib加载的视图，默认是600 * 600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    //视图被添加到 window上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        //视图是使用自动布局来设置的，只是设置了约束
        //当视图被添加到窗口上时，根据父视图的大小，计算约束值，更新控件位置
        // -layoutIfNeeded 会直接按照当前的约束，直接更新控件位置
        // - 执行之后控件所在位置，就是xib中布局约束指定的位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        //如果控件们的 frame 还没有计算好，所有的约束会一起动画
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            //更新约束
            self.layoutIfNeeded()
        }) { (_) in
            
        }
    }

    //自动布局系统更新完成约束后，会调用此方法
    //通常是对子视图布局进行修改
//    override func layoutSubviews() {
//
//    }
    
}
