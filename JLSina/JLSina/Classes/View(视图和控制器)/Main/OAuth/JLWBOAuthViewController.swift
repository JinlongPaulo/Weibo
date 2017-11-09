//
//  JLWBOAuthViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/9.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//通过webView加载新浪微博授权页面控制器
class JLWBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        
        //设置导航栏
        title = "登录新浪微博"
        //导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回" , target: self, action: #selector(close), isBack: true)
    }

    //MARK: - 监听方法
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

}
