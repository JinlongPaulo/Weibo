//
//  JLBaseViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

// MARK: - 设置界面
extension JLBaseViewController {
    @objc dynamic func setupUI() {
        view.backgroundColor = UIColor.cz_random()
    }
}
