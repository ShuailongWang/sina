//
//  WSLSendTextView+Extension.swift
//  weibo-2
//
//  Created by czbk on 16/8/20.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//给文本框添加方法
extension WSLSendTextView {
    /*
    info    ["NSAttachment": <NSTextAttachment: 0x7fc3eac4b700>, "NSFont": <UICTFont: 0x7fc3ead3cc10> font-family: ".SFUIText-Regular"; font-weight: normal; font-style: normal; font-size: 16.00pt]
    range   (0,1)
    ["NSAttachment": <NSTextAttachment: 0x7fc3eaee7ab0>, "NSFont": <UICTFont: 0x7fc3ead3cc10> font-family: ".SFUIText-Regular"; font-weight: normal; font-style: normal; font-size: 16.00pt]
    (1,1)
    ["NSFont": <UICTFont: 0x7fc3ead3cc10> font-family: ".SFUIText-Regular"; font-weight: normal; font-style: normal; font-size: 16.00pt]
    (2,6)
    ["NSAttachment": <NSTextAttachment: 0x7fc3ead4d5e0>, "NSFont": <UICTFont: 0x7fc3ead3cc10> font-family: ".SFUIText-Regular"; font-weight: normal; font-style: normal; font-size: 16.00pt]
    (8,1)
    */
    var emoticonText: String {
        //文本内容
        var temp = ""
        
        /**
        *  富文本
        
        //  info: 富文本内容
        //  range: 富文本的范围
        //  stop: 是否停止
        */
        self.attributedText.enumerateAttributesInRange(NSMakeRange(0, self.attributedText.length), options: []) { (info, range, stop) -> Void in
//            print(info)
//            print(range)
            //判断文本附件是否是我们自定义的
            if let attachement = info["NSAttachment"] as? WSLTextAttachment {
                //表情模型,如果到这里报错的话,那是因为模型没有赋值
                let emoticon = attachement.emoticon!
                
                //图片的描述信息
                temp += emoticon.chs!
            }else {
                //  文本富文本,emoji
                //  获取文本富文本的字符串, 通过指定的范围获取富文本然后再获取富文本对应的字符串
                temp += self.attributedText.attributedSubstringFromRange(range).string
            }
            
        }
        
        return temp
    }
    
    
    //插入表情的富文本
    func insertEmotion(emoticon: WSLEmoticonModel){
        //判断表情类型
        if emoticon.type == "0" {
            //图片的描述信息,textView中有:[马到成功]
            //textView.insertText(emoticon.chs!)
            
            //记录上一次的富文本
            let oldAttributeStr = NSMutableAttributedString(attributedString: self.attributedText)
            
            //1,2,3已经封装,
            let attributedStr = NSAttributedString.attributedStringWithEmoticon(emoticon, font: self.font!)
            
//            //追加富文本(如果添加这个后,点击表情后,是添加了一个,但是到replaceCha哪里的时候,又添加了一个)
//            oldAttributeStr.appendAttributedString(attributedStr)
            
            //选取选中的富文本的范围
            var range = self.selectedRange
            
            //设置选中范围的富文本
            oldAttributeStr.replaceCharactersInRange(range, withAttributedString: attributedStr)
            
            //设置富文本字体的大小
            oldAttributeStr.addAttribute(NSFontAttributeName, value: self.font!, range: NSMakeRange(0, oldAttributeStr.length))
            
            //4,设置富文本
            self.attributedText = oldAttributeStr
            
            //添加一个表情,富文本光标位置+1,选中范围设置为0
            range.location += 1
            range.length = 0
            
            //设置选中的范围
            self.selectedRange = range
            
            //通知方法,文本框内容的通知,判断占位文字的显示与隐藏
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: nil)
            
            //执行代理方法,
            self.delegate?.textViewDidChange!(self)
            
        }else{
            //textView插入内容,相当于添加内容
            //emoji
            self.insertText((emoticon.code! as NSString).emoji())
        }
    }
}
