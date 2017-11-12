//
//  JLWBOAuthViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/9.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit
import SVProgressHUD
//通过webView加载新浪微博授权页面控制器
class JLWBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        //取消滚动视图
        webView.scrollView.isScrollEnabled = false
//        webView.scrollView.bounces = false
        
        //设置代理
        webView.delegate = self
        
        //设置导航栏
        title = "登录新浪微博"
        //导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回" , target: self, action: #selector(close), isBack: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载授权界面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        //1>URL确定要访问的资源
        guard let url = URL(string: urlString) else {
                return
        }
        
        //2>建立请求
        let request = URLRequest(url: url)
        
        //3>加载请求
        webView.loadRequest(request)
        
    }
    
    
    

    //MARK: - 监听方法
    //关闭控制器
    @objc private func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    //自动填充 - webView的注入，直接通过js修改 ‘本地浏览器中‘缓存的页面内容
    //点击登录，执行submit ，将本地的数据提交给服务器
    @objc private func autoFill() {
        //准备js
        let js = "document.getElementById('userId').value = '13611942390';" + "document.getElementById('passwd').value = 'woaini921227';"
        
        //让webView直行js
        webView.stringByEvaluatingJavaScript(from: js)
    }

}

extension JLWBOAuthViewController: UIWebViewDelegate {
    
    //webView: webView
    //request： 要加载的请求
    //UIWebViewNavigationType：导航类型
    //return : 是否加载 request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //确认思路
        //1.如果请求地址包含 http://baidu.com 不加载页面 否则加载界面
        //request.url?.absoluteString.hasPrefix(WBRedirectURI) 返回的是可选项 bool/nil
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        
        
//        print("加载请求---\(String(describing: request.url?.absoluteString))")
        //query 就是URL中‘？’后面的就是query
//        print("加载请求---\(String(describing: request.url?.query))")
        //2.从 http://baidu.com 回调地址里面查询字符串 code=
        //如果有，授权成功 否则授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            
            print("取消授权")
            close()
            return false
        }
        
        //从query字符串中取出授权码
        //代码到此，url中一定有查询字符串，并且包含code
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        //使用授权码获取accessToken
        JLNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
                SVProgressHUD.showInfo(withStatus: "登录成功")
                //跳转界面，如何跳转
                //1,通过通知跳转，发送登录成功消息
                //- 不关心有没有监听者
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue:
                        WBUserLoginSuccessedNotification),
                                                object: nil)
                //2,关闭窗口
                self.close()
            }
            
        }
        print("获取授权码...\(String(describing: code))")
        return false
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
