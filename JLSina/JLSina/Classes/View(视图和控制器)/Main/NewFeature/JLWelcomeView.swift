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
    
    class func welcomeView()-> JLWelcomeView {
        let nib = UINib(nibName: "JLWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! JLWelcomeView
        
        //从xib加载的视图，默认是600 * 600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
}
