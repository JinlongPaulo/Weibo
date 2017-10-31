//
//  JLMainViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//主控制器
class JLMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
    }

}

//extension 类似于OC中的分类，在Swift中可以查分代码块，
//可以把相近功能的函数，放在一个extension中，便于代码维护
//注意：和OC的分类一样，extension 中不能定义属性

//MARK: - 设置界面
extension JLMainViewController {

//设置所有子控制器

    fileprivate func setupChildControllers() {
        addChildViewController(vc: JLHomeViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(vc: JLMessageViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(UIViewController())
        addChildViewController(vc: JLDiscoverViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(vc: JLProfileViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    fileprivate func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        // 设置标题
        vc.title = title
        // 设置图像
        vc.tabBarItem.image = UIImage(named: imageName)
        // 导航控制器
        let nav = UINavigationController(rootViewController: vc)
        addChildViewController(nav)
    }
}

