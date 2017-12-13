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
    
    //标题标签 - 换行热键 option + 回车
    //逐行选中文本并且设置属性
    //如果要想调整行间距，增加空行，设置空行的字体，lineHeight
    @IBOutlet var titleLabel: UILabel!
    
    //工具栏底部约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    //MARK: - 视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        //监听键盘通知 - UIWindow.h
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //激活键盘
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
        //关闭键盘
        textView.resignFirstResponder()
    }
    
    //MARK: - 键盘监听
    @objc private func keyboardChanged(n: Notification) {
//        print(n.userInfo)
        //1,目标rect
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        
       
        
        
        //2,设置底部约束的高度
        let offset = view.bounds.height - rect.origin.y
        
        //3,更新底部约束
        toolBarBottomCons.constant = offset
        
        //动画更新约束
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
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
        setupToolBar()
    }
    
    ///设置工具栏
    func setupToolBar() {
        let itemSettings = [
            ["imageName": "compose_toolbar_picture"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
            ["imageName": "compose_add_background"]
        ]
        
        //遍历数组
        var items = [UIBarButtonItem]()
        
        for s in itemSettings {
            guard let imageName = s["imageName"] else {
                continue
            }
            
            let image = UIImage.init(named: imageName)
            let imageHL = UIImage.init(named: imageName + "_highlighted")
            
            
            let btn = UIButton()
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            
            btn.sizeToFit()
            
            //追加按钮
            items .append(UIBarButtonItem(customView: btn))
            
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        // 删除末尾弹簧
        items.removeLast()
        toolBar.items = items
    }
    
    //设置导航栏
    func setupNavtionBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        //设置发布按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        //设置标题视图
        navigationItem.titleView = titleLabel
        sendButton.isEnabled = false
    }
}
