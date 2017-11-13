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
        
    }
    
    class func newFeatureView()-> JLNewFeatureView {
        let nib = UINib(nibName: "JLNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! JLNewFeatureView
        
        //从xib加载的视图，默认是600 * 600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    

}
