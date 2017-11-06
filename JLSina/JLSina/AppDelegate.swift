//
//  AppDelegate.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = JLMainViewController()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        return true
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
                
                
                data?.write(toFile: jsonPath, atomically: true)
                
                print("应用程序加载完毕 \(jsonPath)")
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

