//
//  JLStatusToolBar.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/15.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

class JLStatusToolBar: UIView {

    var viewModel: JLStatusViewModel? {
        didSet {
            retweetedButton.setTitle("\(viewModel?.status.reposts_count)", for: [])
            commentButton.setTitle("\(viewModel?.status.comments_count)", for: [])

            likeButton.setTitle("\(viewModel?.status.attitudes_count)", for: [])

        }
    }
    
    //转发
    @IBOutlet weak var retweetedButton: UIButton!
    //评论
    @IBOutlet weak var commentButton: UIButton!
    //点赞
    @IBOutlet weak var likeButton: UIButton!

}
