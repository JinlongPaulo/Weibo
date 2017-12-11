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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var sendButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("发布", for: [])
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: [])
        btn.setTitleColor(UIColor.gray, for: .disabled)
        
        //设置背景图片
        btn.setBackgroundImage(UIImage(named: "common_button_orange"), for: [])
        btn.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        
        //设置大小
        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        return btn
    }()
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
