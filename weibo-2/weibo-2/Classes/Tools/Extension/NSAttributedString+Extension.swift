//
//  NSAttributedString+Extension.swift
//  weibo-2
//
//  Created by czbk on 16/8/20.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    /**
     通过表情模型,创建表情富文本对象
     
     - parameter emoticon: 表情模型
     - parameter font:     字体
     */
    class func attributedStringWithEmoticon(emoticon: WSLEmoticonModel, font: UIFont) -> NSAttributedString {
        //1,创建图片
        let image = UIImage(named: emoticon.path!)
        
        //2,创建文本附件,自定义文本附件
        let attachment = WSLTextAttachment()
        
        //模型赋值
        attachment.emoticon = emoticon
        
        //获取文字的行高
        let fontHeight = font.lineHeight
        
        //设置图片大小的位置,设置bounds会影响子控件的布局
        attachment.bounds = CGRect(x: 0, y: -4, width: fontHeight, height: fontHeight)
        
        //设置图片
        attachment.image = image
        
        //3,创建富文本,文本附件
        let attributedStr = NSAttributedString(attachment: attachment)
        
        return attributedStr
    }
}
