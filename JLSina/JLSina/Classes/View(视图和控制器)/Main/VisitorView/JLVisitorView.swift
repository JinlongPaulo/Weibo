//
//  JLVisitorView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/2.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//访客视图
class JLVisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 设置界面
extension JLVisitorView {
    
    func setupUI() {
        backgroundColor = UIColor.white
    }
}
