//
//  JLBaseViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLBaseViewController: UIViewController {

    var tableView: UITableView?
    
    
    //自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.cz_screenWidth(), height: 49))
    
    //自定义的导航项 - 以后使用导航栏内容，统一使用navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //重写title的didSet
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }

}

// MARK: - 设置界面
extension JLBaseViewController {
    @objc dynamic func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        setUpNavigationBar()
        
    }
    
    private func setUpNavigationBar() {
        //添加导航条
        view.addSubview(navigationBar)
        //将item设置给bar
        navigationBar.items = [navItem]
        //设置navbar的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        //设置navbar的字体颜色
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    }
}
