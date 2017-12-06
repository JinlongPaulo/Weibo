//
//  String+Extensions.swift
//  正则表达式
//
//  Created by 盘赢 on 2017/12/6.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import Foundation

extension String {
    
    //<a href=\"http://app.weibo.com/t/feed/4fw5aJ\" rel=\"nofollow\">秒拍网页版</a>
    //从当前字符串中提取链接和文本
    //Swift提供了'元组' , 同时返回多个值
    //如果是OC ，可以返回字典/自定义对象/指针的指针
    func JL_href() -> (link: String , text: String)? {
        
        //0,匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        
        //1,创建正则表达式 , 并且匹配到第一项
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) ,
            let resule = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) else {
            return nil
        }
        
        //2,获取结果
        let link = (self as NSString).substring(with: resule.range(at: 1))
        
        let text = (self as NSString).substring(with: resule.range(at: 2))
        
        
        print(link + "----" + text)
        
        return (link , text)
    }
}
