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
            
            //测试修改配图视图的高度
//            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            //设置配图视图的url数据
            //测试4张图像
//            if (viewModel?.status.pic_urls?.count)! > 4 {
//                //将末尾的数据全部删除
//                var picUrls = viewModel!.status.pic_urls!
//                picUrls.removeSubrange((picUrls.startIndex + 4)..<picUrls.endIndex)
//                pictureView.urls = picUrls
//            } else {
//                
//                pictureView.urls = viewModel?.status.pic_urls
//            }
            //设置配图（被转发和原创）
            pictureView.urls = viewModel?.picURLs
            
            //设置被转发微博的文字
            retweetedLabel?.text = viewModel?.retweetedText
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
