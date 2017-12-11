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
        
        refreshControl?.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.listViewModel.loadStatus (pullup: self.isPullup) { (isSuccess , shouldRefresh) in
                
                
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
        //0,取出视图模型，根据视图模型，判断可重用cell
        let vm = listViewModel.statusList[indexPath.row]
        
        let cellId = vm.status.retweeted_status != nil ? retweetedCellId : originalCellId
        
        //FIXME: 修改id
        //1,取cell - 本身会调用代理方法(如果有)
        //如果没有，找到cell，按照自动布局的规则，从上向下计算，找到向下的约束，从而动态计算行高
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JLStatusCell
        //2,设置cell
        cell.viewModel = vm
        
        //设置代理,只是传递了一个指针
        cell.delegate = self
        //3,返回cell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //1.根据indexpath获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        //返回行高
        return vm.rowHeight
        
    }
}

//  MARK: - JLStatusCellDelegate
extension JLHomeViewController: JLStatusCellDelegate {
    func statusCellDidSelectedURLString(cell: JLStatusCell, urlString: String) {
        print(urlString)
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
//        tableView?.rowHeight = UITableViewAutomaticDimension
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
