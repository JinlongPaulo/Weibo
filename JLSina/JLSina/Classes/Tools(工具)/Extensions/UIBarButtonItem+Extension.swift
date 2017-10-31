//
//  UIBarButtonItem+Extension.swift
//  JLSina
//
//  Created by 盘赢 on 2017/10/31.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    

    /**
     //创建UIbarButtonItem
    **/
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject?, action: Selector,isBack: Bool = false) {
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        if isBack {
            let imageName = "next_black"
            
            btn.setImage(UIImage(named: imageName), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imageName + "_orange"), for: .highlighted)
            btn.imageRect(forContentRect: CGRect(x: 0, y: 0, width: 14, height: 20))
        }
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        //self.init实例化
        self.init(customView: btn)
    }
 
}

