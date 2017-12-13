//
//  JLComposeTextView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/12/13.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//撰写微博的文本视图
class JLComposeTextView: UITextView {

    //占位标签
    private lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        setupUI()
    }
}

private extension JLComposeTextView {
    func setupUI() {
        
        //1,设置占位标签
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5 , y: 8)
        
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
    }
}
