//
//  CZEmoticonLayout.swift
//  表情键盘
//
//  Created by 盘赢 on 2017/12/14.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import UIKit

//表情个集合视图的布局
class CZEmoticonLayout: UICollectionViewFlowLayout {

    //prepare 就是OC中的 prepareLayout
    override func prepare() {
        super.prepare()
        //设定滚动方向
        //水平方向滚动，cell垂直布局
        //垂直方向滚动，cell水平方向布局
        scrollDirection = .horizontal
    }
}
