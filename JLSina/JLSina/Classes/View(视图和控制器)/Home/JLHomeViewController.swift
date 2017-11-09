//
//  JLHomeViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//定义全局常量，尽量使用private修饰
private let cellId = "cellId"

class JLHomeViewController: JLBaseViewController {

    
    //列表视图模型
    private lazy var listViewModel: JLStatusListViewModel = JLStatusListViewModel()
    //加载数据
    //模拟“延时”加载数据
    override func loadData() {
        
        listViewModel.loadStatus (pullup: self.isPullup) { (isSuccess , shouldRefresh) in
            
            
            //结束刷新控件
            self.refreshControl?.endRefreshing()
            //恢复上拉刷新标记
            self.isPullup = false
            //刷新表格
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    
    //显示好友
    @objc private func showFriends() {
        print(#function)
        let vc = JLDemoViewController()
        //push的动作是NAV做的
        navigationController?.pushViewController(vc, animated: true)
        
    }

}

//MARK: - 表格数据源方法,具体的数据源方法实现，不需要super
extension JLHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1,取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        //2,设置cell
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text
        //3,返回cell
        return cell
    }
}

//MARK: - 设置界面
extension JLHomeViewController {
    //重写父类方法
    override func setupTableView() {
        super.setupTableView()
        //设置导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        //注册原型cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

}
