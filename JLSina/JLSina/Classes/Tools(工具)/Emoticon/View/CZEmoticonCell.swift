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
    
    var emoticons:[CZEmoticon]? {
        //当前页面表情模型数组，'最多'20个
        didSet {
//            print("表情包数量\(emoticons?.count)")
            //1,隐藏所有按钮
            for v in contentView.subviews {
                v.isHidden = true
            }
            
            contentView.subviews.last?.isHidden = false
            
            //2,遍历表情模型数组
            for (i,em) in (emoticons ?? []).enumerated() {
                //1,取出按钮
                if let btn = contentView.subviews[i] as? UIButton {
                    
                    //设置图像 - 如果图像为nil，会清空图像，避免复用
                    btn.setImage(em.image, for: [])
                    
                    //设置emoji 的字符串 - 如果emoji为nil，会清空emoji，避免复用
                    btn.setTitle(em.emoji, for: [])
                    
                    btn.isHidden = false
                }
                
                //取出末尾删除按钮
                let removeButton = contentView.subviews.last as! UIButton
                //设置图像
                let image = UIImage.init(named: "compose_emotion_delete_highlighted", in: CZEmoticonManager.shared.bundle, compatibleWith: nil)
                
                removeButton.setImage(image, for: [])
                
                
            }
        }
    }
    
    
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("aa")
    }
    //XIB加载测试
//    override func awakeFromNib() {
//        setupUI()
//    }
}

//MARK: - 设置界面
private extension CZEmoticonCell {
    
    // - 从xib加载，cell.bounds是XIB中定义的大小，不是size的大小
    // - 从纯代码创建，cell.bounds就是布局属性中设置的itemSize
    func setupUI() {
        //连续创建21个按钮
        let rowCount = 3
        let colCount = 7
        
        //左右间距
        let leftMargin: CGFloat = 8
        //底部间距，为分页控件预留控件
        let bottonMargin: CGFloat = 16
        
        let w = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let h = (bounds.height - bottonMargin) / CGFloat(rowCount)
        
        
        
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton()
            //设置按钮大小
            let x = leftMargin + CGFloat(col) * w
            let y = CGFloat(row) * h
            
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            //设置按钮字体,lineHeight基本上和图片大小差不多
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            contentView.addSubview(btn)
        }
    }
}
