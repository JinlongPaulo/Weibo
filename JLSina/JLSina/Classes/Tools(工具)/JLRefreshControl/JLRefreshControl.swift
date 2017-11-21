//
//  JLRefreshControl.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/20.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//刷新控件
class JLRefreshControl: UIControl {
    
    //MARK: - 属性
    //刷新控件的父视图，下拉视图刷新控件应该适用于，UITableView / UICollectionView
    private weak var scrollView: UIScrollView?
    
    //MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    /*
     newSuperview : addSubView 方法会调用
     - 当添加到父视图的时候，newSuperview是父视图
     - 当父视图被移除， newSuperview 是 nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        print(newSuperview)
        //判断父视图的类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        //记录父视图
        scrollView = sv
        
        //KVO 监听父视图的contentOffset
        //在程序中，通常只监听某一个对象的某几个属性，如果属性太多，方法会很乱
        //观察者模式，在不需要的时候，需要释放
        // - 通知中心: 如果不释放，什么也不会发生，但是会有内存泄露，会有多次注册可能
        // - KVO : 如果不释放，会崩溃
        scrollView?.addObserver(self, forKeyPath: "ContentOffset", options: [], context: nil)
    }
    
    //本视图从父视图上移除
    //提示：所有下拉刷新框架，都是监听父视图的ContentOffset
    //所有框架的KVO监听实现思路，都是这个
    override func removeFromSuperview() {
        //super还存在
        superview?.removeObserver(self, forKeyPath: "ContentOffset")
        super.removeFromSuperview()
        //super不存在
    }
    
    //所有KVO方法会统一调用此方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //contentOffset 的 y值跟 contentInset 的top有关
        print(scrollView?.contentOffset)
        
        guard let sv = scrollView else {
            return
        }
        //初始高度就应该是 0
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        //可以根据高度设置刷新控件的frame
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        
    }
    
    //开始刷新
    func beginRefreshing() {
        print("开始刷新")
    }
    

    func endRefreshing() {
        print("结束刷新")
    }
}


extension JLRefreshControl {
    
    private func setupUI() {
        backgroundColor = UIColor.yellow
    }
}
