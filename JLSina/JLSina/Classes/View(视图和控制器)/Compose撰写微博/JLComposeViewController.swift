//
//  JLComposeViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/12/5.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//撰写微博控制器
/*
 加载视图控制器的时候，如果XIB和控制器重名，默认的构造函数会优先加载XIB
 */
class JLComposeViewController: UIViewController {

    //文本编辑视图
    @IBOutlet weak var textView: UITextView!
    //底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    //发布按钮
    @IBOutlet var sendButton: UIButton!
    
    //MARK: - 视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 监听方法
    //发布微博
    @IBAction func postStatus() {
        
    }
    
}

private extension JLComposeViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavtionBar()
    }
    
    //设置导航栏
    func setupNavtionBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        //设置发布按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        sendButton.isEnabled = false
    }
}
