//
//  CZEmoticonPackage.swift
//  表情包数据
//
//  Created by 盘赢 on 2017/12/7.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import UIKit
import YYModel

//表情包模型
@objcMembers
class CZEmoticonPackage: NSObject {
    //表情包分组名
    var groupName: String?
    
    //背景图片名称
    var bgImageName: String?
    
    
    //表情包目录，从目录下加载info.plist可以创建表情模型数组
    var directory: String? {
        didSet {
            //当设置目录时，从目录下加载info.plist
            guard let directory = directory ,
                  let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil) ,
                  let bundle = Bundle(path: path) ,
                  let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory) ,
                  let array = NSArray(contentsOfFile: infoPath) as? [[String : String]] ,
                  let models = NSArray.yy_modelArray(with: CZEmoticon.self, json: array) as? [CZEmoticon] else {
                
                return
            }

            //遍历models数组，设置每一个表情符号的目录
            for m in models {
                m.directory = directory
            }

            //设置表情模型数组
            emoticons += models

        }
    }
    
    //懒加载的表情模型的空数组
    //使用懒加载可以避免后续解包
    lazy var emoticons = [CZEmoticon]()
    
    override var description: String {
        return yy_modelDescription()
    }
}
