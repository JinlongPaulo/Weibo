//
//  JLStatusPictureView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/16.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLStatusPictureView: UIView {
    
    var viewModel: JLStatusViewModel? {
        didSet {
            calcViewSize()
        }
    }
    
    //根据视图模型的配图视图大小，调整显示内容
    private func calcViewSize() {
        //修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    
    //配图视图的数组
    var urls: [JLStatusPicture]? {
        didSet {
            
            //1,隐藏所有的imageView
            for v in subviews {
                v.isHidden = true
            }
            
            //2,遍历urls数组，顺序设置图像
            var index = 0
            for url in urls ?? [] {
                
                //获得对应索引的imageView
                let iv = subviews[index] as! UIImageView
                //4张图像处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                //设置图像
                iv.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                //显示图像
                iv.isHidden = false
                index += 1
                
            }
        }
    }
    
    
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
        //设置背景颜色
        backgroundColor = superview?.backgroundColor
        
        //超出边界的内容不显示
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: JLStatusPictureViewOutterMargin, width: JLStatusPictureItemWidth, height: JLStatusPictureItemWidth)
        
        for i in 0..<count * count {
            let iv = UIImageView()
            
            //设置contentMode
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
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
