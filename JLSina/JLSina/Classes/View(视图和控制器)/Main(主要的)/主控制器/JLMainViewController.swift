//
//  JLMainViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit
import SVProgressHUD
//主控制器
class JLMainViewController: UITabBarController {

    //定时器
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        setupChildControllers()
        setupCompostButton()
        setupTimer()
        
        //设置新特性视图
        setupNewFeatureViews()
        //设置代理
        delegate = self
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        //销毁定时器
        timer?.invalidate()
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    /**
     portrait  :竖屏, 肖像
     landscape :横屏, 风景画❀
     - 使用代码控制设备的方向，好处：可以在需要横屏的时候单独处理
     - 设置支持的方向之后，当前的控制器及子控制器都会遵守这个方向
     - 如果播放视频，通常是通过 modal 展现的!
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - 监听方法
    @objc private func userLogin(n: NSNotification) {
//        print("用户登录通知\(n)") 
        
        var  when = DispatchTime.now()
        
        //判断n.object是否有值->token过期，如果有值，提示用户重新登录
        if n.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            //修改延迟时间
            when = DispatchTime.now() + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            SVProgressHUD.setDefaultMaskType(.clear)
            //展现登录控制器 - 通常会和 UINavtigationController连用，方便返回
            let nav = UINavigationController(rootViewController: JLWBOAuthViewController())
            
            self.present(nav, animated: true, completion: nil)
        }
    
    }
    
    //MARK: - 撰写微博
  @objc private func compostStatus() {
//        print("撰写微博")
    //FIXME: 0 > 判断是否登录
    
    //1>实例化视图
    let v = JLComposeTypeView.composeTypeView()
    
    //2>显示视图 - 注意闭包循环引用
    v.show { [weak v] (clsName) in
//        print(clsName)
        //展现撰写微博控制
        guard let clsName = clsName ,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type else {
                v?.removeFromSuperview()
            return
        }
        
        
        let vc = cls.init()
        
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true) {
            v?.removeFromSuperview()
        }
        
    }
    
    }
    //MARK: -私有控件
    //撰写按钮
    private lazy var compostButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

}

//MARK: - 新特性视图处理
extension JLMainViewController {
    
    //设置新特性视图
    private func setupNewFeatureViews() {
        
        //0,判断是否登录
        if !JLNetworkManager.shared.userLogon {
            return
        }
        //1,检查版本是否更新
        
        //2,如果更新，显示新特性，否则显示欢迎
        let v = isNewVersion ? JLNewFeatureView.newFeatureView() : JLWelcomeView.welcomeView()

        view.addSubview(v)
        //3,添加视图
    }
    
    //extension中可以有计算型属性，不会占用存储空间
    //构造函数：给属性分配空间
    /**
     版本号
     - 在AppStore 每次升级应用程序，版本号都需要增加，不能递减
     - 组成 主版本号,次版本号,修订版本号
     - 主版本号：意味着大的修改，使用者也需要做大的使用
     - 此版本号：意味着小的修改，某些函数和方法的使用或者参数有变化
     - 修订版本号：框架/程序内部 bug 的修订，不会对使用者造成任何的影响
     */
    private var isNewVersion: Bool {
        //1,取当前版本号 1.0.2
//        print(Bundle.main.infoDictionary)
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        print("当前版本" + currentVersion)
        
        //2,取保存在‘Document(iTunes备份)[最理想保存在用户偏好里面（UserDefaults）]’目录中的之前的版本号 "1.0.1"
        let path: String = ("version" as NSString).cz_appendDocumentDir()
        
        let sandboxVersion = (try? String(contentsOfFile:path)) ?? ""
        print("沙盒版本" + sandboxVersion)
        print(path)
        //3,将当前版本号保存在沙盒 1.0.2
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        //4,返回两个版本是否一致 new
        return currentVersion != sandboxVersion
    }
}

//MARK: - UITabBarControllerDelegate
extension JLMainViewController: UITabBarControllerDelegate {
    
    //将要选择tabbarItem
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        print("将要切换到\(viewController)")
        
        //1,获取控制器在数组中的索引
        let idx = (childViewControllers as NSArray).index(of: viewController)
        //2,判断当前索引是首页，同时idx也是首页,重复点击首页按钮
        if selectedIndex == 0 && idx == selectedIndex {
//            print("点击首页")
            //3>让表格滚动到顶部
            //a)获取到控制器
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! JLHomeViewController
            
            //b)滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x: 0 ,y: -64), animated: true)
            
            //4> 刷新数据 - 增加延迟，保证表格先滚动到顶部，再刷新
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                 vc.loadData()
            })
            
            //5>清除tabbarItem的badgeNumber
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
            
        }
        //判断目标控制器是否是UIViewController
        
        return !viewController.isMember(of: UIViewController.self)
    }
}


//MARK: - 时钟相关方法
extension JLMainViewController {
    //定义时钟
    private func setupTimer() {
        //时间间隔建议长一些
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    //时钟触发方法
    @objc private func updateTimer() {
        
        if !JLNetworkManager.shared.userLogon {
            return
        }
        
        JLNetworkManager.shared.unreadCount { (count) in
            //设置首页tabbard的badgeNumber
//            print("检测到\(count)条新微薄")
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            //设置app的badgeNum,从iOS8.0之后，要用户授权之后才能显示
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

//extension 类似于OC中的分类，在Swift中可以查分代码块，
//可以把相近功能的函数，放在一个extension中，便于代码维护
//注意：和OC的分类一样，extension 中不能定义属性

//MARK: - 设置界面
extension JLMainViewController {

    private func setupCompostButton() {
        tabBar.addSubview(compostButton)
        //计算按钮位置
        let count = CGFloat(childViewControllers.count)
        //将向内缩进宽度
        let w = tabBar.bounds.width / count
        
        //CGRectInset 正数向内缩进，负数向外扩展
        compostButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        //按钮监听方法
        compostButton.addTarget(self, action: #selector(compostStatus), for: .touchUpInside)
        
    }
    
    
    //使用字典创建一个子控制器
    //dict:信息字典[clsName , title , imageName , "visitorInfo"]
    private func controller(dict: [String: AnyObject]) -> UIViewController {
        //1，取得字典内容
        guard let clsName = dict["clsName"] as? String ,
         let title = dict["title"] as? String ,
         let imageName = dict["imageName"] as? String ,
         let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? JLBaseViewController.Type ,
         let visitorDict = dict["visitorInfo"] as? [String: String]
            
        else {
            return UIViewController()
        }
        
        //创建视图
        let vc = cls.init()
        vc.title = title
        
        //设置控制器访客信息字典
        vc.visitorInfoDictionary = visitorDict
        
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName + ".png")
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        //设置tabbar标题字体
        vc.tabBarItem.setTitleTextAttributes(
            [NSAttributedStringKey.foregroundColor: UIColor.orange], for: .highlighted)
        
       //系统默认12号字
      vc.tabBarItem.setTitleTextAttributes(
        [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        
        let nav = JLNavigationController(rootViewController: vc)
        return nav
    }
    
//设置所有子控制器
    private func setupChildControllers() {

        //获取沙盒json路径
        let docDic = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let jsonPath = (docDic as NSString).appendingPathComponent("main.json")
        //加载data
        var data = NSData(contentsOfFile: jsonPath)
        
        //判断data是否有内容，如果没有，说明本地沙盒没有文件
        if data == nil {
            //从bundle加载data
            let path = Bundle.main.path(forResource: "main.json" , ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        //data一定会有一个内容，反序列化
        //1,路径 2,加载NSData 3,反序列化转换成数组
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]]
        else  {
            return
        }
        
       
        
//        //现在的很多应用程序中，界面的创建都依赖网络json
//        let array: [[String: AnyObject]] = [
//            ["clsName": "JLHomeViewController" as AnyObject,
//             "title": "首页" as AnyObject ,
//             "imageName": "home" as AnyObject ,
//             "visitorInfo": ["imageName":"" ,
//             "message":"关注一些人，回这里看看有什么惊喜"] as AnyObject
//            ],
//
//            ["clsName": "JLMessageViewController" as AnyObject ,
//             "title": "消息" as AnyObject ,
//             "imageName": "message_center" as AnyObject,
//             "visitorInfo": ["imageName":"visitordiscover_image_message" ,
//              "message":"登录后，别人评论你的微博，发给你的消息，都会在这里收到通知"] as AnyObject
//            ],
//
//            ["clsName": "UIViewController" as AnyObject],
//
//            ["clsName": "JLDiscoverViewController" as AnyObject ,
//             "title": "发现" as AnyObject ,
//             "imageName": "discover" as AnyObject,
//             "visitorInfo": ["imageName":"visitordiscover_signup_logo" ,
//             "message":"登录后，最新,最热微博尽在掌握，不再会与实事潮流擦肩而过"] as AnyObject
//            ],
//
//            ["clsName":"JLProfileViewController" as AnyObject ,
//             "title":"我" as AnyObject ,
//             "imageName":"profile" as AnyObject,
//             "visitorInfo": ["imageName":"visitordiscover_image_profile" ,
//             "message":"登录后，你的微博,相册,个人资料会显示在这里，展示给别人看"] as AnyObject
//            ]
//        ]
//
        
        //测试数据格式是否正确，转换成plist数据更加直观
//        (array as NSArray).write(toFile: "/Users/panying/Desktop/demo.plist", atomically: true)
        
        //数组 -> json序列号
//        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])

//        (data as NSData).write(toFile: "Users/panying/Desktop/demo.json", atomically: true)
//        data.write(to: fileURL)
        
        //遍历数组，循环创建控制器数组
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        
        //设置tabbar的子控制器
        viewControllers = arrayM
        
    }
    
}

