//
//  CZEmoticonTipView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/12/20.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

/// 表情选择提示视图
class CZEmoticonTipView: UIImageView {
    
    init() {
        
        let bundle = CZEmoticonManager.shared.bundle
        let image = UIImage.init(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        // [[UIImageView alloc] initWithImage: image] => 会根据视图大小设置图像视图的大小
        super.init(image: image)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
