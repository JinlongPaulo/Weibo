//
//  JLBaseViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//面试题：OC中支持多继承吗？如果不支持，如何替代
//答案：使用协议替代
//Swift的写法更类似于多继承!
//class JLBaseViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
//Swift中，利用extension 可以把函数按照功能分类管理，便于阅读和维护
//注意：
//1,extension 中不能有属性
//2,extension 不能重写父类方法!重写父类方法，是子类的职责，扩展是对类的扩展！

//所有主控制器的基类控制器
class JLBaseViewController: UIViewController {
    

    //表格视图 - 如果用户没有登录，就不创建
    var tableView: UITableView?
    //刷新控件
    var refreshControl: UIRefreshControl?
    //上拉刷新标记
    var isPullup = false
    
    
    //自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.cz_screenWidth(), height: 49))
    
    //自定义的导航项 - 以后使用导航栏内容，统一使用navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData()
    }
    
    //重写title的didSet
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    //加载数据 - 具体实现，由子类负责
    @objc func loadData() {
        //如果子类不实现任何方法，默认关闭刷新
        refreshControl?.endRefreshing()
    }

}

// MARK: - 设置界面
extension JLBaseViewController {
    @objc dynamic func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        //取消自动缩进 - 如果隐藏了导航栏，会缩进20个点(目前版本不设置也好)
        automaticallyAdjustsScrollViewInsets = false
        setUpNavigationBar()
        setupTableView()
    }
    
    //设置表格视图
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        //设置数据源和代理 ->让子类直接实现数据源方法
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.showsVerticalScrollIndicator = false
        //设置内容缩进
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: 0, right: 0)
        
        //设置刷新控件
        //1,实例化控件
        refreshControl = UIRefreshControl()
        let str = NSAttributedString(string: "正在刷新")
        
        refreshControl?.attributedTitle = str
        refreshControl?.tintColor = UIColor.orange
        //2,添加到表格视图
        tableView?.addSubview(refreshControl!)
        
        //3,添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    //设置导航条
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

//MARK: - UITableViewDelegate , UITableViewDataSource
extension JLBaseViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //基类只是准备方法，子类负责具体实现
    //子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //只是保证没有语法错误
        return UITableViewCell()
    }
    
    //在显示最后一行的时候，做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //1,判断indexPath是否是最后一行
        //(indexPath.section(最大) / indexPath.row(最后一行))
        //1>row
        let row = indexPath.row
        //2> section
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        //3,行数
        let count = tableView.numberOfRows(inSection: section)
        
        //如果是最后一行，同时没有开始上拉刷新
        if row == count - 1 && !isPullup {
            print("上拉刷新")
            isPullup = true
            //开始刷新
            loadData()
        }
        
        print("section--\(section)")
    
        
    }
}
