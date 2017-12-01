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

}

//private 让extension中所有方法都是私有的
private extension JLComposeTypeView {
    func setupUI() {
        //1,创建类型按钮
        let btn = JLComposeTypeButton.composeTypeButton(imageName: "tabbar_compose_music", title: "试一试")
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        addSubview(btn)
        
        //添加监听方法
        btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
}
