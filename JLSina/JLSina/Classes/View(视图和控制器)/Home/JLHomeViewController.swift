//
//  JLHomeViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//定义全局常量，尽量使用private修饰
//原创微博可重用cellid
private let originalCellId = "originalCellId"
//被转发微博的可重用cellid
private let retweetedCellId = "retweetedCellId"

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
        //FIXME: 修改id
        let cell = tableView.dequeueReusableCell(withIdentifier: retweetedCellId, for: indexPath) as! JLStatusCell
        //2,设置cell
        let vm = listViewModel.statusList[indexPath.row]
        
        cell.viewModel = vm
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
        tableView?.register(UINib(nibName: "JLStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "JLStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        //设置行高
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        //取消分割线
        tableView?.separatorStyle = .none
        setNavTitle()
    }
    
    
    //设置导航栏标题
    private func setNavTitle() {
        
        
        let title = JLNetworkManager.shared.userAccount.screen_name

        let button = JLTitleButton(title: title)
        
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
    }
    
    @objc func clickTitleButton(btn: UIButton) {
        //设置选中状态
        btn.isSelected = !btn.isSelected
        
    }

}
