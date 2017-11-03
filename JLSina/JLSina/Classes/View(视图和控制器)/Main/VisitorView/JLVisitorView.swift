//
//  JLVisitorView.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/2.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//访客视图
class JLVisitorView: UIView {

    //访客视图的信息字典 [imageName / message]
    //如果是首页 imageName == ""
    var visitorInfo: [String: String]? {
        didSet {
            //1>取字典信息
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            
            //2>设置消息
            tipLabel.text = message
            
            //3>设置图像，首页不需要设置
            if imageName == "" {
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            //其他控制器的访客视图不需要显示小房子,遮罩视图
            houseIconView.isHidden = true
            maskIconView.isHidden = true
            
        }
    }
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    //MARK: - 私有控件
    //懒加载属性只有调用UIKit 控件的指定构造函数，其他都需要使用类型
    // 图像视图
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //遮罩图像
    private lazy var maskIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    //小房子
    private lazy var houseIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //提示标签
    private lazy var tipLabel: UILabel = UILabel.cz_label(
        withText: "关注一些人，回这里看看有什么惊喜",
        fontSize: 14,
        color: UIColor.darkGray)
    //注册按钮
    private lazy var registerBtn: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    //登录按钮
    private lazy var loginBtn: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
}

//MARK: - 设置界面
extension JLVisitorView {
    
    func setupUI() {
        //在开发的时候，如果能够使用颜色，就不要使用图像,效率会更高
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        //1,添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        tipLabel.textAlignment = .center
        //2,取消 autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        //3,自动布局
        let margin: CGFloat = 20.0
        
        //1>图像视图
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -50))
        //2>小房子
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        
        //3>提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 236))
        tipLabel.textAlignment = .center
        //4>注册
        addConstraint(NSLayoutConstraint(item: registerBtn,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
         addConstraint(NSLayoutConstraint(item: registerBtn,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: tipLabel,
                                          attribute: .bottom,
                                          multiplier: 1.0,
                                          constant: margin))
        addConstraint(NSLayoutConstraint(item: registerBtn,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        //5>登录
        addConstraint(NSLayoutConstraint(item: loginBtn,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: loginBtn,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerBtn,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
        
        //6>遮罩
        //views:定义VFL中的控件名称和实际名称的映射关系
        //metrics:定义VFL中（）指定的常数映射关系
        let viewDict = [
            "maskIconView": maskIconView,
            "registerBtn": registerBtn] as [String : Any]
        
        let metrics = ["spacing":15]
        
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDict))
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerBtn]",
            options: [],
            metrics: metrics,
            views: viewDict))

    }
}
