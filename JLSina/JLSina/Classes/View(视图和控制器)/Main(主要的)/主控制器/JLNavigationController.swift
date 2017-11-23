//
//  JLNavigationController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏默认的Navigation
        navigationBar.isHidden = true

    }
    
    //重写push方法，所有的push方法都会调用此方法!
    //viewController被push的控制器，设置他的左侧按钮作为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        //如果不是栈底控制器才需要隐藏
        if childViewControllers.count > 0 {
            //隐藏底部 tabbar
            viewController.hidesBottomBarWhenPushed = true
            
            //判断控制器的类型
            if let vc = viewController as? JLBaseViewController {
                var title = "返回"
                //判断控制器的级数,只有一个子控制器的时候，显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                //取出自定义的navItem
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent), isBack: true)
            }
        }
        

        super.pushViewController(viewController, animated: true)

    }
    
    //POP返回到上一级控制器
    @objc private func popToParent() {
        popViewController(animated: true)
    }


}
