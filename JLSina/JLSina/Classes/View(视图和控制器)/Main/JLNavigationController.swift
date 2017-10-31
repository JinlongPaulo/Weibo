//
//  JLNavigationController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLNavigationController: UINavigationController {
    
    //重写push方法，所有的push方法都会调用此方法!
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print(viewController)
        //如果不是栈底控制器才需要隐藏
        if childViewControllers.count > 0 {
            //隐藏底部 tabbar
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)

    }


}
