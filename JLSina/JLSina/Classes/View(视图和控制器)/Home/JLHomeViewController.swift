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
//        vc.hidesBottomBarWhenPushed = true
        //push的动作是NAV做的
        navigationController?.pushViewController(vc, animated: true)
        
    }

}

//MARK: - 设置界面
extension JLHomeViewController {
    //重写父类方法
    override func setupUI() {
         super.setupUI()
        //设置导航栏按钮
        //无法高亮
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
        //Swift调用OC返回instancetype的方法，判断不出是否可选
        let btn: UIButton = UIButton.cz_textButton("好友", fontSize: 14, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
}
