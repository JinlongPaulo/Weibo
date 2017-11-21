//
//  AppDelegate.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //应用程序额外设置
        setupAdditions()
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = JLMainViewController()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        return true
    }

}

//MARK: - 设置应用程序额外信息
extension AppDelegate {
    
    private func setupAdditions() {
        //1,设置SVProgressHUD最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        
        //2,设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        //3,设置用户授权显示通知
        //#available 是检测设备版本，如果是10.0以上
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .carPlay , .sound]) { (success, error) in
                print("授权" + (success ? "成功":"失败"))
            }
        } else {
            // 10.0以下
            //取得用户授权显示通知[上方提示条/声音/badgeNumber]
            let notifySettings = UIUserNotificationSettings(types: [.alert , .badge , .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifySettings)
        }
    }
}

//MARK: - 从服务器加载应用
extension AppDelegate {

    private func loadAppInfo() {
        
        //1，模拟异步
        if #available(iOS 8.0, *) {
            DispatchQueue.global().async {
                //1,url
                let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
                
                //2,data
                let data = NSData(contentsOf:url!)
                
                //3,写入磁盘
                let docDic = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                
                let jsonPath = (docDic as NSString).appendingPathComponent("main.json")
                
                //直接保存在沙盒，等待下一次程序启动使用
                data?.write(toFile: jsonPath, atomically: true)
                
//                print("应用程序加载完毕 \(jsonPath)")
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

