//
//  UIBarButtonItem+Extension.swift
//  JLSina
//
//  Created by 盘赢 on 2017/10/31.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    

    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject?, action: Selector) {
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        //self.init实例化
        self.init(customView: btn)
    }
 
}

