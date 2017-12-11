//
//  JLWebViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/12/11.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//网页控制器
class JLWebViewController: JLBaseViewController {
    
    private lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    //要加载的url字符串
    var urlString: String? {
        didSet {
            guard let urlString = urlString ,
                  let url = URL(string: urlString) else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
}

extension JLWebViewController {
    
    override func setupTableView() {
        //设置标题
        navItem.title = "网页"
        //设置webView
        view.insertSubview(webView, belowSubview: navigationBar)
        webView.backgroundColor = UIColor.white
        
        //设置contentInset
        webView.scrollView.contentInset.top = navigationBar.bounds.height
    }
}
