//
//  JLNewFeatureView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/13.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLNewFeatureView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    //进入微博
    @IBAction func enterStatus() {
        removeFromSuperview()
    }
    
    class func newFeatureView()-> JLNewFeatureView {
        let nib = UINib(nibName: "JLNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! JLNewFeatureView
        
        //从xib加载的视图，默认是600 * 600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    
    override func awakeFromNib() {
        //如果使用自动布局设置的界面，从XIB加载 ，默认是 600 * 600大小
        //添加4个图像视图
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            let imageName = "new_feature_\(i + 1)"
            let iv = UIImageView(image: UIImage.init(named: imageName))
            //设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(iv)
        }
        
        //指定scrollView的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        //隐藏按钮
        enterButton.isHidden = true
    }
    
}

extension JLNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //1,滚动到最后一屏，让视图删除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        //2,判断是否最后一页
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
        //3,如果是倒数第二页，显示按钮
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0,一旦滚动隐藏按钮
        enterButton.isHidden = true
        //1,计算当前的偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        //2,设置分页控件
        pageControl.currentPage = page
        
        //3,分页控件隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}
