//
//  CZEmoticonManager.swift
//  表情包数据
//
//  Created by 盘赢 on 2017/12/6.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import UIKit

//表情管理器
class CZEmoticonManager {
    
    //为了便于表情复用，建立一个单例，只加载一次表情数据
    //表情管理器的单例
    static let shared = CZEmoticonManager()
    
    //表情包的懒加载数组
    lazy var packages = [CZEmoticonPackage]()
    
    //构造函数,如果在init之前增加修饰符，可以要求访问者，必须通过 shared 访问对象
    //OC需要重写allocWithZone方法
    private init() {
        loadPackages()
    }
}

//MARK: - 表情字符串处理
extension CZEmoticonManager {
    
    /// 将给定字符串转换成属性文本
    ///
    // 关键点： 要按照匹配结果倒序替换属性字符串
    /// - Parameter string: 完整的字符串
    /// - Returns: 属性文本
    func emoticonString(string: String , font: UIFont) -> NSAttributedString {
        
        //NSAttributedString 是不可变的
        
        let attrString = NSMutableAttributedString(string: string)
        
        //1,建立正则表达式，过滤所有的文字
        // (), []都是正则表达式的关键字，如果要参与匹配，需要转义
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        
        //2，匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        //3,遍历所有匹配结果
        for m in matches.reversed() {
            let r = m.range(at: 0)
            let subString = (attrString.string as NSString).substring(with: r)
            
            //1>使用substring，查找对应的表情符号
            if let em = CZEmoticonManager.shared.findEmoticon(string: subString) {
                print(em)
                
                //2>使用表情符号中的属性文本，替换原有的属性文本内容
                attrString.replaceCharacters(in: r, with: em.imageText(font: font))
                
            }
            
        }
        
        //4,统一设置一遍字符串的属性
        attrString.addAttributes([NSAttributedStringKey.font: font], range: NSRange(location: 0, length: attrString.length))
        return attrString
    }
    
    /// 根据string '[爱你]' 在所有的表情符号中，查找对应的表情模型对象
    ///
    /// - 如果找到返回表情模型，
    /// - 否则返回nil
    func findEmoticon(string: String) -> CZEmoticon? {
        //1,遍历表情包
        //OC中过滤数组，使用谓词，
        for p in packages {
            //2，在表情数组中，过滤string
            //方法1
//            let result = p.emoticons.filter({ (em) -> Bool in
//                return em.chs == string
//            })
            //方法2 尾随闭包
//            let result = p.emoticons.filter() { (em) -> Bool in
//                return em.chs == string
//            }
            //方法3 - 如果闭包中只有一句，并且是返回
            //1,闭包格式定义可以省略
            //2,参数省略之后，使用$0 , $1 ,,,一次替代原有参数
//            let result = p.emoticons.filter() {
//                return $0.chs == string
//            }
            
            //方法3 - 如果闭包中只有一句，并且是返回
            //1,闭包格式定义可以省略
            //2,参数省略之后，使用$0 , $1 ,,,一次替代原有参数
            //3,return 也可以省略
            let result = p.emoticons.filter() { $0.chs == string }
            
            //3，判断结果数组的数据
            if result.count == 1 {
                return result[0]
            }
        }
        return nil
    }
}

//MARK: - 表情包数据处理
private extension CZEmoticonManager {
    
    func loadPackages() {
        
        //读取emoticon.plist
        //只要按照bundle默认的目录结构设定，就可以直接读取 Resources目录下的文件
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil) ,
              let bundle = Bundle(path: path) ,
              let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil) ,
              let array = NSArray(contentsOfFile: plistPath) as? [[String : String]] ,
              let models = NSArray.yy_modelArray(with: CZEmoticonPackage.self, json: array) as? [CZEmoticonPackage]
        else {
            return
        }
        
        //设置表情包数据
        //使用+= 不需要再次给 packages 分配空间，直接追加数据
        packages += models
    }
    
}
