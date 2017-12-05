//
//  JLComposeTypeView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/12/1.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit
import pop

//撰写微博类型视图
class JLComposeTypeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    //关闭按钮约束
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    //返回前一页按钮约束
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    //返回前一页按钮
    @IBOutlet weak var returnButton: UIButton!
    private let buttonsInfo = [
        ["imageName":"tabbar_compose_idea" , "title":"文字"] ,
        ["imageName":"tabbar_compose_photo" , "title":"照片/视频"] ,
        ["imageName":"tabbar_compose_weibo" , "title":"长微博"] ,
        ["imageName":"tabbar_compose_lbs" , "title":"签到"] ,
        ["imageName":"tabbar_compose_review" , "title":"点评"] ,
        ["imageName":"tabbar_compose_more" , "title":"更多" , "actionName":"clickMore"] ,
        ["imageName":"tabbar_compose_friend" , "title":"好友圈"] ,
        ["imageName":"tabbar_compose_wbcamera" , "title":"微博相机"] ,
        ["imageName":"tabbar_compose_music" , "title":"音乐"] ,
        ["imageName":"tabbar_compose_shooting" , "title":"拍摄"]
    ]
    
    class func composeTypeView() -> JLComposeTypeView {
        let nib = UINib(nibName: "JLComposeTypeView", bundle: nil)
        
        //从XIB加载完成，就会调用awakeFromNib
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! JLComposeTypeView
        
        //XIB加载，默认600 * 600
        v.frame = UIScreen.main.bounds
        v.setupUI()
        return v
    }
    
    //显示当前视图
    func show() {
        //1>将当前视图添加到跟视图控制器
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        //2> 添加视图
        vc.view .addSubview(self)
        
        //3>开始动画
        showCurrentView()
    }
    
    
    //MARK: 监听方法
    @objc private func clickButton() {
        print("点我了")
    }
    
    //点击更多按钮
    @objc private func clickMore() {
//        print("点击更多")
        //将scrollview滚动到第二页
        let offSet = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offSet, animated: true)
        
        //处理底部按钮,让两个按钮分开
        returnButton.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        
        closeButtonCenterXCons.constant += margin
        returnButtonCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
        
    }

    
    @IBAction func clickReturn() {
        //将滚动视图滚动到第1页
        scrollView.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
        
        //让两个按钮合并
        closeButtonCenterXCons.constant = 0
        returnButtonCenterXCons.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }) { (_) in
            self.returnButton.isHidden = true
            self.returnButton.alpha = 1
        }
    }
    //关闭视图
    @IBAction func close() {
        removeFromSuperview()
    }
}

//MARK: - 动画方法扩展
private extension JLComposeTypeView {
    //动画显示当前视图
    private func showCurrentView() {
        
        //1，创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.5
        
        //2,添加到视图
        pop_add(anim, forKey: nil)
        
        //3,添加按钮的方法
        showButtons()
    }
    
    //弹力显示所有按钮
    private func showButtons() {
        //1,获取所有 scrollview 的子视图的第0个视图
        let v = scrollView.subviews[0]
        
        //2,遍历 v 中所有按钮
        for (i ,btn) in v.subviews.enumerated() {
            //1，创建动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            //2,设置动画属性
            anim.fromValue = btn.center.y + 300
            anim.toValue = btn.center.y
            //弹力系数，取值范围[0~20]，数值越大，弹性越大，默认值为4
            anim.springBounciness = 8
            //弹力速度,取值范围[0~20]，数值越大，速度越快，默认值为12
            anim.springSpeed = 8
            
            //设置动画启动时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            //3,添加动画
            btn.pop_add(anim, forKey: nil)
            
        }
        
    }
}

//private 让extension中所有方法都是私有的
private extension JLComposeTypeView {
    func setupUI() {
        //0,强行更新布局
        layoutIfNeeded()
        //1,向scrollview添加视图，然后向视图添加按钮
        let rect = scrollView.bounds
        
        let width = scrollView.bounds.width
        
        
        for i in 0..<2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            //        //2,向视图添加按钮
            addButtons(v: v, idx: i * 6)
            //        //3,将视图添加到scrollview
            scrollView.addSubview(v)
        }
        
        //4,设置scrollview
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        //禁用滚动
        scrollView.isScrollEnabled = false
    }
    
    
    ///1, 向V中添加按钮，按钮的数组索引从 idx 开始
    func addButtons(v: UIView , idx: Int) {
        let count = 6
        //从idx开始，添加6个按钮
        for i in idx..<(idx + count) {
            
            if i >= buttonsInfo.count {
                break
            }
            //0,从数组字典中获取名称和title
            let dict = buttonsInfo[i]
            guard let imageName = dict["imageName"] ,
                  let title = dict["title"] else {
                    continue
            }
            
            
            //1,创建按钮
            let btn = JLComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            //2,将btn添加到视图
            v.addSubview(btn)
            //3,添加监听方法
            if let actionName = dict["actionName"] {
//                #selector(clickMore)
                //OC中使用 NSSelectorFromString("clickMore")
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
        }
        
        //2,遍历视图子视图，布局按钮
        //准备常量
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        
        for (i , btn) in v.subviews.enumerated() {
            let y: CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            
            let x = (CGFloat(col) + 1) * margin + CGFloat(col) * btnSize.width
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
    }
}
