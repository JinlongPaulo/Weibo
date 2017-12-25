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
    @IBOutlet weak var toolBar: CZEmoticonToolBar!
    
    //选中表情回调闭包属性
    private var selectedEmoticonCallBack: ((_ emoticon: CZEmoticon?)->())?
    ///加载并且返回输入视图
    class func inputView(selectedEmoticon: @escaping (_ emoticon: CZEmoticon?)->()) -> CZEmoticonInputView {
        let nib = UINib(nibName: "CZEmoticonInputView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! CZEmoticonInputView
        
        //记录闭包
        v.selectedEmoticonCallBack = selectedEmoticon
        
        return v
    }
    
    override func awakeFromNib() {
        collectionView.backgroundColor = UIColor.white
        //注册可重用cell
        collectionView.register(CZEmoticonCell.self, forCellWithReuseIdentifier: cellId)
        
        //设置工具栏代理
        toolBar.delegate = self
    }
}

extension CZEmoticonInputView : CZEmoticonToolBarDelegate {
    
    func emoticonToolBarDidSelectedItemIndex(toolBar: CZEmoticonToolBar, index: Int) {
        
    }
}

extension CZEmoticonInputView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //1,取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CZEmoticonCell
        
        //2,设置cell - 传递对应页面的表情数组
        cell.emoticons = CZEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
        //设置代理 - 不适合用闭包
        cell.delegate = self
        //3,返回cell
        return cell
    }
    
    //分组数量 - 返回表情包的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CZEmoticonManager.shared.packages.count
    }
    
    //返回每个分组中表情页的数量
    //每个分组的表情包中，表情页面的数量 emoticons 数组 / 20
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CZEmoticonManager.shared.packages[section].numberOfPages
    }
}

//MARK: - CZEmoticonCellDelegate
extension CZEmoticonInputView: CZEmoticonCellDelegate {
    
    
    /// 选中的表情回调
    ///
    /// - Parameters:
    ///   - cell: 分页cell
    ///   - em: 选中的表情，删除键为nil
    func CZEmoticonCellDidSelectedEmoticon(cell: CZEmoticonCell, em: CZEmoticon?) {
//        print(em)
        //执行闭包回调选中的表情
        selectedEmoticonCallBack?(em)
        
        //添加最近使用的表情
        guard let em = em else {
            return
        }
        
        //如果当前 collectionView 就是最近分组，不添加最近使用的表情
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        
        if indexPath.section == 0 {
            return
        }
        
        //添加最近使用的表情
        CZEmoticonManager.shared.recentEmoticon(em: em)
        
        //刷新数据 - 第0组
        var indexSet = IndexSet()
        indexSet.insert(0)
        collectionView.reloadSections(indexSet)
    }
}
