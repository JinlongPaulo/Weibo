//
//  JLMeituanRefreshView.swift
//  刷新控件
//
//  Created by 盘赢 on 2017/11/23.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLMeituanRefreshView: JLRefreshView {

    @IBOutlet weak var buildingIconView: UIImageView!
    
    
    @IBOutlet weak var earthIconView: UIImageView!
    
    @IBOutlet weak var kangarooIconView: UIImageView!
    
    override func awakeFromNib() {
        //1,房子
        let bImage1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bImage2 = #imageLiteral(resourceName: "icon_building_loading_2")
        
        buildingIconView.image = UIImage.animatedImage(with: [bImage1 , bImage2], duration: 0.5)
        
        //2.地球
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = -2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        
        anim.isRemovedOnCompletion = false
        
        earthIconView.layer.add(anim, forKey: nil)
        
        //3,袋鼠
        //1>设置锚点
        kangarooIconView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        //2>设置center
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 27
        
        kangarooIconView.center = CGPoint(x: x,
                                          y: y)
        
        kangarooIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        
        
    }
}
