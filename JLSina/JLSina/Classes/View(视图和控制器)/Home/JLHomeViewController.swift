//
//  JLHomeViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLHomeViewController: JLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //显示好友
    @objc private func showFriends() {
        print(#function)
        let vc = JLDemoViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
    }

}

//MARK: - 设置界面
extension JLHomeViewController {
    //重写父类方法
    override func setupUI() {
         super.setupUI()
        //设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
    }
}
