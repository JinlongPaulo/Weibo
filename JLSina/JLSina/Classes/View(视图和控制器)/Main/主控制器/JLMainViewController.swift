//
//  JLMainViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/9/29.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//主控制器
class JLMainViewController: UITabBarController {

    //定时器
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
        setupCompostButton()
        setupTimer()
        
        //设置代理
        delegate = self
    }
    
    deinit {
        //销毁定时器
        timer?.invalidate()
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
    //FIXME:没有实现
    //@objc 能够保证用OC方式访问，允许这个函数在运行时通过OC的消息机制被调用
    //private 能够保证方法私有，仅在当前对象内访问
  @objc private func compostStatus() {
        print("撰写微博")
        //测试方向旋转
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.cz_random()
        let nav = UINavigationController(rootViewController: vc)
    
        present(nav, animated: true, completion: nil)
    
    
    }
    //MARK: -私有控件
    //撰写按钮
    private lazy var compostButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

}

//MARK: - UITabBarControllerDelegate
extension JLMainViewController: UITabBarControllerDelegate {
    
    //将要选择tabbarItem
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        print("将要切换到\(viewController)")
        
        //1,获取控制器在数组中的索引
        let idx = (childViewControllers as NSArray).index(of: viewController)
        //2,判断当前索引是首页，同时idx也是首页,重复点击首页按钮
        if selectedIndex == 0 && idx == selectedIndex{
            print("点击首页")
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
            
        }
        //判断目标控制器是否是UIViewController
        
        return !viewController.isMember(of: UIViewController.self)
    }
}


//MARK: - 时钟相关方法
extension JLMainViewController {
    //定义时钟
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    //时钟触发方法
    @objc private func updateTimer() {
        JLNetworkManager.shared.unreadCount { (count) in
            //设置首页tabbard的badgeNumber
            print("检测到\(count)条新微薄")
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
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_highlighted")?.withRenderingMode(.alwaysOriginal)
        
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
//                             "message":"关注一些人，回这里看看有什么惊喜"] as AnyObject
//            ],
//
//            ["clsName": "JLMessageViewController" as AnyObject ,
//             "title": "消息" as AnyObject ,
//             "imageName": "message_center" as AnyObject,
//             "visitorInfo": ["imageName":"visitordiscover_image_message" ,
//                             "message":"登录后，别人评论你的微博，发给你的消息，都会在这里收到通知"] as AnyObject
//            ],
//
//            ["clsName": "UIViewController" as AnyObject],
//
//            ["clsName": "JLDiscoverViewController" as AnyObject ,
//             "title": "发现" as AnyObject ,
//             "imageName": "discover" as AnyObject,
//             "visitorInfo": ["imageName":"visitordiscover_signup_logo" ,
//                             "message":"登录后，最新,最热微博尽在掌握，不再会与实事潮流擦肩而过"] as AnyObject
//            ],
//
//            ["clsName":"JLProfileViewController" as AnyObject ,
//             "title":"我" as AnyObject ,
//             "imageName":"profile" as AnyObject,
//             "visitorInfo": ["imageName":"visitordiscover_image_profile" ,
//                             "message":"登录后，你的微博,相册,个人资料会显示在这里，展示给别人看"] as AnyObject
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

