//
//  JLComposeTypeButton.swift
//  JLSina
//
//  Created by 盘赢 on 2017/12/1.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//UIControl 内置了 touchupInside 时间相应 
class JLComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    /// 使用图像名称和标题创建按钮，按钮布局从xib加载

    class func composeTypeButton(imageName: String , title: String) -> JLComposeTypeButton {
        
        let nib = UINib(nibName: "JLComposeTypeButton", bundle: nil)
        
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! JLComposeTypeButton
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        return btn
    }
    
    
}
