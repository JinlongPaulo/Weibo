//
//  CZEmoticonCell.swift
//  表情键盘
//
//  Created by 盘赢 on 2017/12/14.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import UIKit

//表情的页面cell，
//每一个cell用九宫格算法，自行添加20个表情,
//每一个cell和CollectionView一样大小
//最后一个位置，放置删除按钮
class CZEmoticonCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        setupUI()
    }
}

//MARK: - 设置界面
private extension CZEmoticonCell {
    
    //从xib加载，bounds是XIB中定义的大小，不是size的大小
    func setupUI() {
        //连续创建21个按钮
        let rowCount = 3
        let colCount = 7
        
        
        for i in 0..<21 {
            let row = i / colCount
            let col = i % rowCount
            
            let btn = UIButton()
            btn.backgroundColor = UIColor.red
            contentView.addSubview(btn)
        }
    }
}
