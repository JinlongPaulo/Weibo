//
//  JLStatusViewModel.swift
//  JLSina
//
//  Created by 盘赢 on 2017/11/15.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import Foundation

//单条微博的视图模型
/**
 如果没有任何父类，如果希望在开发时调试，输出调试信息
 1，遵守 CustomStringConvertible
 2，实现 description 计算型属性
 
 关于表格的性能优化
 - 尽量少计算，所有的素材提前计算好
 - 控件上不要设置圆角半径，所有图像渲染的属性，都要注意
 - 不要动态创建空间，所有需要的控件，都要提前创建好，在显示的时候，根据数据隐藏，显示
 (用内存换取CPU)
 - cell中控件的层次越少越好，数量越少越好
 - 要测量，不要猜测！
*/
class JLStatusViewModel: CustomStringConvertible {

    //微博模型
    var status: JLStatus
    
    //会员图标
    var memberIcon: UIImage?
    
    //认证类型。-1：没有认证 0：认证用户，2,3,5企业认真 ， 220：达人
    var vipIcon: UIImage?
    
    //转发文字
    var retweetedStr: String?
    //评论文字
    var commentsStr: String?
    //点赞文字
    var likeStr: String?
    
    //配图视图大小
    var pictureViewSize = CGSize()
    
    //如果是被转发的微博，原创微博一定没有图片
    var picURLs: [JLStatusPicture]? {
        //如果有被转发的微博，返回被转发微博配图
        //如果没有被转发的微博，返回原创微博的配图
        //如果都没有，返回 nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    //被转发微博文字
    var retweetedText: String?
    
    //行高
    var rowHeight: CGFloat = 0
    
    
    //构造函数
    init(model: JLStatus) {
        self.status = model
        //common_icon_membership_level1
        //会员等级0-6
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            
            memberIcon = UIImage.init(named: imageName)
        }
        
        //认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage.init(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage.init(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage.init(named: "avatar_grassroot")
        default:
            break
        }
        
//        model.reposts_count = Int(arc4random_uniform(100000))
        //设置底部计数字符串
        retweetedStr = countString(count: status.reposts_count, defaultString: "转发")
        commentsStr = countString(count: status.comments_count, defaultString: "评论")
        likeStr = countString(count: status.attitudes_count, defaultString: "点赞")
        
        //计算配图视图大小(有原创，计算原创，有转发计算转发)
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        
        //设置被转发微博文字
        let subStr = "@" + (status.retweeted_status?.user?.screen_name ?? "") + ":"
        retweetedText = subStr + (status.retweeted_status?.text ?? "")
        
        //计算行高
        updateRowHeight()
    }
    
    //根据当前视图模型内容，计算行高
    func updateRowHeight() {
        
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolBarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        
        //1,计算顶部位置
        height = 2 * margin + iconHeight + margin
        
        //2,正文高度
        if let text = status.text {
           height += (text as NSString).boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: originalFont], context: nil).height
        }
        
        //3,判断是否转发微博
        if status.retweeted_status != nil {
            height += 2 * margin
            //转发文本的高度 - 一定用retweetedText，拼接过后的字符串
            if let text = retweetedText {
               height += (text as NSString).boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: retweetedFont], context: nil).height
            }
        }
        
        //4,配图视图
        height += pictureViewSize.height
        
        height += margin
        
        //5,底部工具栏
        height += toolBarHeight
        
        //6,使用属性记录
        rowHeight = height
    }
    
    //使用单个图像，更新配图视图的大小
    //image:网络缓存的单张图像
    func updateSingleImageSize(image: UIImage) {
        var size = image.size
        
        //注意，尺寸需要增加顶部12个点，便于布局
        size.height += JLStatusPictureViewOutterMargin
        
        //重新设置配图视图大小
        pictureViewSize = size
        //更新行高
        updateRowHeight()
    }
    
    //计算指定数量的图片，对应的配图视图的大小
    //count:配图数量   return：配图视图大小
    private func calcPictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil{
            return CGSize()
        }
        
        
        //2,计算高度
        //1>,根据count知道行数 1-9
        let row = (count! - 1) / 3 + 1
        
        //2>根据行数算高度
        var height = JLStatusPictureViewOutterMargin
            height += CGFloat(row) * JLStatusPictureItemWidth
            height += CGFloat(row - 1) * JLStatusPictureViewInnerMargin
        
        return CGSize(width: JlStatusPictureViewWidth, height: height)
    }
    
    
    //给定一个数字，返回对应的描述函数
    //count 数字
    //defailtString 默认字符串 转发/评论/赞
    //returns: 描述结果
    /**
     0 - 显示默认标题
     > 10000  ,显示x.xx万
     < 10000  ,显示实际数字
     */
    private func countString(count: Int , defaultString: String) -> String {
        if count == 0 {
            return defaultString
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%.02f 万" , Double(count / 10000))
    }
    
    var description: String {
        return status.description
    }
}
