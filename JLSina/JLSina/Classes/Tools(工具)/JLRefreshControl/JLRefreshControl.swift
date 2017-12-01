//
//  JLRefreshControl.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/20.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//刷新状态切换的临界点
//FIXME: 刷新控件位置问题
private let JLRefreshOffset: CGFloat = 127


/// 刷新状态
///
/// - Normal: 普通状态,什么都不错
/// - Pulling: 超过临界点，如果放手，开始刷新
/// - WillRefresh: 用户超过临界点，并且放手
enum JLRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

//刷新控件 - 负责刷新相关的逻辑处理
class JLRefreshControl: UIControl {
    
    //MARK: - 属性
    //刷新控件的父视图，下拉视图刷新控件应该适用于，UITableView / UICollectionView
    private weak var scrollView: UIScrollView?
    
    //刷新视图
    private lazy var refreshView: JLRefreshView = JLRefreshView.refreshView()
    
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
//        print(scrollView?.contentOffset)
        
        guard let sv = scrollView else {
            return
        }
        //初始高度就应该是 0
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        
        //可以根据高度设置刷新控件的frame
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        
        print(height)
        //判断临界点 - 只需要判断一次
        if sv.isDragging {
            
            if height > JLRefreshOffset && refreshView.refreshState == .Normal {
                print("放手刷新")
                refreshView.refreshState = .Pulling
            } else if height <= JLRefreshOffset && refreshView.refreshState == .Pulling {
                
                refreshView.refreshState = .Normal
                print("再拉")
            }
            
        } else {
            //放手 - 判断是否超过临界点
            if refreshView.refreshState == .Pulling {
                print("准备开始刷新")
                
                beginRefreshing()
                //发送刷新数据事件
                sendActions(for: .valueChanged)
                
                
            }
        }
    }
    
    //开始刷新
    func beginRefreshing() {
        print("开始刷新")
        //判断父视图
        guard let sv = scrollView else { return }
        
        //判断是否正在刷新，如果正在刷新，直接返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
        //设置刷新视图的状态
        refreshView.refreshState = .WillRefresh
        
        //调整表格间距
        //解决方法： 修改表格的contentInset
        var inset = sv.contentInset
        
        //FIXME: 刷新控件位置问题
        inset.top += JLRefreshOffset
        
        sv.contentInset = inset
        //如果开始调用beginRefresh 会重复发送刷新事件
//        sendActions(for: .valueChanged)
    }
    

    func endRefreshing() {
        print("结束刷新")
        
        guard let sv = scrollView else {
            return
        }
        
        //判断状态，是否正在刷新，如果不是，直接返回
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        //恢复刷新视图的状态
        refreshView.refreshState = .Normal
        //恢复表格视图的contentInset
        var inset = sv.contentInset
        inset.top -= JLRefreshOffset
        
        sv.contentInset = inset
        
    }
}


extension JLRefreshControl {
    
    private func setupUI() {

        backgroundColor = super.backgroundColor
        //设置超出边界不显示
//        clipsToBounds = true
        //添加刷新视图 - 从xib加载出来，默认是xib中指定的宽高
        addSubview(refreshView)
        
        //自动布局 - 设置xib 控件的自动布局，需要指定宽高约束
        //先回原生的写法，如果自己开发框架，不能用任何的自动布局框架
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
}
