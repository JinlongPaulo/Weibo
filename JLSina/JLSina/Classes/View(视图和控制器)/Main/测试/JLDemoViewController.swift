//
//  JLDemoViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/10/31.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLDemoViewController: JLBaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        //设置标题
        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
    }
    //继续push新的控制
    @objc private func showNext() {
        let vc = JLDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension JLDemoViewController {
    override func setupUI() {
        super.setupUI()
        //设置右侧控制器
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", style: .plain, target: self, action: #selector(showNext))
        
        let btn: UIButton = UIButton.cz_textButton("下一个", fontSize: 14, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(self, action: #selector(showNext), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
}
