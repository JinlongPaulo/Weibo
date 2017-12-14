//
//  CZEmoticonToolBar.swift
//  表情键盘
//
//  Created by 盘赢 on 2017/12/14.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import UIKit

//表情键盘底部工具栏
class CZEmoticonToolBar: UIView {

    override func awakeFromNib() {
        setupUI()
    }
    
    override func layoutSubviews() {
        //布局所有按钮
        let count = subviews.count
        let w = bounds.width / CGFloat(count)
        
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        
        
        for (i, btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
        
    }
}

private extension CZEmoticonToolBar {
    
    func setupUI() {
        //0,获取表情包管理单例
        let manager = CZEmoticonManager.shared
        //1,从表情包的分组名称->设置按钮
        for p in manager.packages {
            //1,实例化按钮
            let btn = UIButton()
            
            //2,设置按钮
            btn.setTitle(p.groupName, for: [])
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.white, for: [])
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            
            btn.sizeToFit()
            //3,添加按钮
            addSubview(btn)
        }
    }
}
