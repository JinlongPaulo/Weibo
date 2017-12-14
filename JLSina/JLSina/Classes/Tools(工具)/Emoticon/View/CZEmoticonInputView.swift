//
//  CZEmoticonInputView.swift
//  表情键盘
//
//  Created by 盘赢 on 2017/12/13.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import UIKit

//表情输入视图
class CZEmoticonInputView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIView!
    ///加载并且返回输入视图
    class func inputView() -> CZEmoticonInputView {
        let nib = UINib(nibName: "CZEmoticonInputView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! CZEmoticonInputView
        
        
        return v
        
        
    }
    
}
