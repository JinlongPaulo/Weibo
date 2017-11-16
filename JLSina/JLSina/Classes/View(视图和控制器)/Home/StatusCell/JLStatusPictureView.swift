//
//  JLStatusPictureView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/16.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLStatusPictureView: UIView {
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!

    override func awakeFromNib() {
        setupUI()
    }
}

//MARK: - 设置界面
extension JLStatusPictureView {
    //1,cell中所有的控件都提前设置好
    //2,设置的时候，根据数据决定是否显示
    //3,不要动态创建控件
    private func setupUI(){
        //超出边界的内容不显示
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: JLStatusPictureViewOutterMargin, width: JLStatusPictureItemWidth, height: JLStatusPictureItemWidth)
        
        for i in 0..<count * count {
            let iv = UIImageView()
            iv.backgroundColor = UIColor.yellow
            
            //行 - Y
            let row = CGFloat(i / count)
            
            //列 - X
            let col = CGFloat(i % count)
            
            let xOffset = col * (JLStatusPictureItemWidth + JLStatusPictureViewInnerMargin)
            
            let yOffset = row * (JLStatusPictureItemWidth + JLStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(iv)
        }
    }
}
