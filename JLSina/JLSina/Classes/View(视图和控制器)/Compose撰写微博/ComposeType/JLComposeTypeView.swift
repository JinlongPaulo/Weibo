//
//  JLComposeTypeView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/12/1.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//撰写微博类型视图
class JLComposeTypeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    private let buttonsInfo = [
        ["imageName":"tabbar_compose_idea" , "title":"文字"] ,
        ["imageName":"tabbar_compose_photo" , "title":"照片/视频"] ,
        ["imageName":"tabbar_compose_weibo" , "title":"长微博"] ,
        ["imageName":"tabbar_compose_lbs" , "title":"签到"] ,
        ["imageName":"tabbar_compose_review" , "title":"点评"] ,
        ["imageName":"tabbar_compose_more" , "title":"更多"] ,
        ["imageName":"tabbar_compose_friend" , "title":"好友圈"] ,
        ["imageName":"tabbar_compose_wbcamera" , "title":"微博相机"] ,
        ["imageName":"tabbar_compose_music" , "title":"音乐"] ,
        ["imageName":"tabbar_compose_shooting" , "title":"拍摄"]
    ]
    
    class func composeTypeView() -> JLComposeTypeView {
        let nib = UINib(nibName: "JLComposeTypeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! JLComposeTypeView
        
        //XIB加载，默认600 * 600
        v.frame = UIScreen.main.bounds
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
        
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    //MARK: 监听方法
    @objc private func clickButton() {
        print("点我了")
    }

    //关闭视图
    @IBAction func close() {
        removeFromSuperview()
    }
}

//private 让extension中所有方法都是私有的
private extension JLComposeTypeView {
    func setupUI() {
    
    }
}
