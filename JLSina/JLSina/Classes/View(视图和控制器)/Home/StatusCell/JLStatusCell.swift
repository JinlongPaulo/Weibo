//
//  JLStatusCell.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/14.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLStatusCell: UITableViewCell {

    var viewModel: JLStatusViewModel? {
        didSet {
            //微博文本
            statusLabel?.text = viewModel?.status.text
            //姓名
            nameLabel.text = viewModel?.status.user?.screen_name
            //设置会员图标 - 直接获取属性，不需要计算
            memberIconView.image = viewModel?.memberIcon
            //认证图标
            vipIconView.image = viewModel?.vipIcon
            
            //用户头像
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage.init(named: "avatar_default_big") , isAvatar: true)
            
            //底部工具栏
            toolBar.viewModel = viewModel
            
            //配图视图视图模型
            pictureView.viewModel = viewModel
            
            //设置被转发微博的文字
            retweetedLabel?.text = viewModel?.retweetedText
            
            //设置来源
//            print("来源\(String(describing: viewModel?.status.source))")
            sourceLabel.text = viewModel?.status.source
//            sourceLabel.text = viewModel?.sourceStr
            
        }
    }
    
    //头像
    @IBOutlet weak var iconView: UIImageView!
    //姓名
    @IBOutlet weak var nameLabel: UILabel!
    //会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    
    //来源
    @IBOutlet weak var sourceLabel: UILabel!
    //认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    //微博正文
    @IBOutlet weak var statusLabel: UILabel!
    
    //底部工具栏
    @IBOutlet weak var toolBar: JLStatusToolBar!
    
    //配图视图
    @IBOutlet weak var pictureView: JLStatusPictureView!
    
    //被转发微博标签 - 原创微博没有此控件，一定要用？
    @IBOutlet weak var retweetedLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //离屏渲染 - 异步绘制
        self.layer.drawsAsynchronously = true
        
        //栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕上滚动的时候。本质上滚动的是这张图片
        //cell 优化，要尽量减少图层的数量，相当于就只有一层
        //停止滚动之后可以接收监听
        self.layer.shouldRasterize = true
        
        //使用栅格化必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
    }


}
