//
//  JLTitleButton.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/13.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLTitleButton: UIButton {

    //重载构造函数
    //title 如果是 nil，就显示首页，
    //如果不为nil，显示昵称和箭头图像
    init(title: String?) {
        super.init(frame: CGRect())
        
        //1,判断title是否为nil
        if title == nil {
            setTitle("首页", for: [])
        } else {
            setTitle(title! + " ", for: [])
            //设置图像
            setImage(UIImage.init(named: "navigationbar_arrow_down"), for: [])
            setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        //2,设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
    
        //3,设置大小
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel ,
              let imageView = imageView else {
            return
        }
        print("\(titleLabel),\(imageView)")
        //将label的x向左移动imageView的宽度，
        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
        //将imageView的x向右移动label的宽度
        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width , dy: 0)
    }
    
}
