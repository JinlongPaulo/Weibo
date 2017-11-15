//
//  UIImageView+WebImage.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/15.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    //隔离SDWebImage设置图像函数
    //urlString: urlSring
    //placeholderImage: 占位图像
    //isAvatar : 是否是头像
    func cz_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        
        //处理url
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        
        //可选项只是用在Swift，OC有的时候用，同样可以传入
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self] (image, _, _, _) in
            
            //完成回调 - 判断是否是头像
            if isAvatar {
                self?.image = image?.cz_avatarImage(size: self?.bounds.size)
            }
        }
    }
}
