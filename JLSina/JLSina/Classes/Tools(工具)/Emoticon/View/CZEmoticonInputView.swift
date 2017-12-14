//
//  CZEmoticonInputView.swift
//  表情键盘
//
//  Created by 盘赢 on 2017/12/13.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import UIKit

//可重用标识符
private let cellId = "cellId"

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
    
    override func awakeFromNib() {
        collectionView.backgroundColor = UIColor.white
        //注册可重用cell
        let nib = UINib(nibName: "CZEmoticonCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }
}

extension CZEmoticonInputView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //1,取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CZEmoticonCell
        
        //2,设置cell
        cell.label.text = "\(indexPath.section).\(indexPath.item)"
        
        //3,返回cell
        return cell
    }
    
    //分组数量 - 返回表情包的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CZEmoticonManager.shared.packages.count
    }
    
    //返回每个分组中表情页的数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
}
