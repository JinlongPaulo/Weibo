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

    //微博数据源数组
    private lazy var statusList = [String]()
    
    //加载数据
    //模拟“延时”加载数据
    override func loadData() {
        
        print("开始加载数据")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            for i in 0..<15 {
                if self.isPullup {
                    self.statusList.append("上拉\(i)")
                } else {
                    self.statusList.insert(i.description, at: 0)
                }
            }
            print("刷新表格")
            //结束刷新控件
            self.refreshControl?.endRefreshing()
            //恢复上拉刷新标记
            self.isPullup = false
            //刷新表格
            self.tableView?.reloadData()
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
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1,取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        //2,设置cell
        cell.textLabel?.text = statusList[indexPath.row]
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
