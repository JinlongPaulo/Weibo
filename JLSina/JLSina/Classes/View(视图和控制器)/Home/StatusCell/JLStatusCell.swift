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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
