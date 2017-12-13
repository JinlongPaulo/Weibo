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
    
    //MARK: - 监听方法
    @objc private func textChanged(n: Notification) {
    
        //如果有文本，不显示标签，否则显示
        placeholderLabel.isHidden = self.hasText
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//extension JLComposeTextView: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        print("哈哈")
//    }
//}

private extension JLComposeTextView {
    func setupUI() {
        
        //0.注册通知 ,
        //- 通知是一对多，如果其他控件监听当前文本视图的通知，不会影响
        //- 如果使用代理，其他控件就无法使用代理监听通知！
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChanged),
                                               name: NSNotification.Name.UITextViewTextDidChange,
                                               object: self)
        
        //1,设置占位标签
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5 , y: 8)
        
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        
        //2,测试代理 - 自己当自己的代理
//        self.delegate = self
    }
}
