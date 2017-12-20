//
//  CZEmoticonCell.swift
//  表情键盘
//
//  Created by 盘赢 on 2017/12/14.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import UIKit

//表情cell的协议
@objc protocol CZEmoticonCellDelegate: NSObjectProtocol {
    
    
    /// 表情cell选中表情模型
    ///
    /// - Parameter em: 表情模型 / nil 表示删除
    func CZEmoticonCellDidSelectedEmoticon(cell: CZEmoticonCell ,em: CZEmoticon?)
}

//表情的页面cell，
//每一个cell用九宫格算法，自行添加20个表情,
//每一个cell和CollectionView一样大小
//最后一个位置，放置删除按钮
class CZEmoticonCell: UICollectionViewCell {
    
    //代理不能用let
    weak var delegate: CZEmoticonCellDelegate?
    
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
            }
        }
    }
    
    ///标题选择提示视图
    private lazy var tipView = CZEmoticonTipView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 当视图从界面上删除,同样会调用此方法，newWindow == nil
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard let w = newWindow else {
            return
        }
        
        // 将提示视图添加到窗口上
        // 提示：在 iOS 6.0 之前，很多程序员都喜欢把控件往窗口添加
        // 在现在开发，如果有地方，就不要用窗口!
        w.addSubview(tipView)
    }
    
    //XIB加载测试
//    override func awakeFromNib() {
//        setupUI()
//    }
    
    //MARK: - 监听方法
    /// 选中表情按钮
    ///
    /// - Parameter button:
    @objc private func selectedEmoticonButton(button: UIButton) {
        
        //1,去 tag 0 ~ 20 ，20对应的是删除按钮
        let tag = button.tag
        
        //2，根据tag,判断是否是删除按钮，如果不是删除按钮，取得表情
        var em: CZEmoticon?
        if tag < (emoticons?.count)! {
            em = emoticons?[tag]
        }
        
        //3,em选中的模型，如果为nil，是删除按钮
        delegate?.CZEmoticonCellDidSelectedEmoticon(cell: self, em: em)
        
    }
    
    /// 长按手势识别 - 是一个非常重要的手势
    /// 可以保证一个对象监听两种点击手势，而且不需要考虑解决手势冲突
    @objc private func longGesture(gusture: UILongPressGestureRecognizer) {
        
        //测试添加提示视图
//        addSubview(tipView)
    }
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
            
            //设置按钮的tag
            btn.tag = i
            //添加监听方法
            btn.addTarget(self, action: #selector(selectedEmoticonButton), for: .touchUpInside)
            
            //取出末尾删除按钮
            let removeButton = contentView.subviews.last as! UIButton
            //设置图像
            let image = UIImage.init(named: "compose_emotion_delete_highlighted", in: CZEmoticonManager.shared.bundle, compatibleWith: nil)
            removeButton.setImage(image, for: [])
            
            //添加长按手势
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longGesture))
            longPress.minimumPressDuration = 0.5
            addGestureRecognizer(longPress)
            
        }
    }
}
