//
//  WSLStatusViewModel.swift
//  weibo-2
//
//  Created by czbk on 16/8/12.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//微博数据处理ViewModel 对应的视图是首页自定义的cell
class WSLStatusViewModel: NSObject {
    //提供微博数据模型
    var statusModel: WSLStatus?
    
    var leftButtonCount: String?        //转发数
    var centerButtonCount: String?      //评论数
    var rightButtonCount: String?       //赞数

    var sourceContent: String?          //来源内容
    var retweetContent: String?         //转发内容
    
    var mbrankImage: UIImage?           //会员等级
    var verifiedTypeImage: UIImage?     //认证类型
    
    var origianAttributedString: NSAttributedString?        //微博正文内容->富文本
    var retweetAttributedString: NSAttributedString?        //转发微博内容->富文本
    
    //时间
    var time: String? {
        guard let creadDate = statusModel?.created_at else {
            return nil
        }
        //获取发微博的时间
        let timeDate = NSDate.sinaDate(creadDate)
        
        //返回 时间处理的属性
        return timeDate.sinaDateStr
    }
    
    init(statusModel: WSLStatus){
        super.init()
        
        //赋值
        self.statusModel = statusModel
        
        //处理转发,评论,赞的逻辑处理
        leftButtonCount = handleCount(statusModel.reposts_count, defaultTitle: "转发")
        centerButtonCount = handleCount(statusModel.comments_count, defaultTitle: "评论")
        rightButtonCount = handleCount(statusModel.attitudes_count, defaultTitle: "赞")
        
        //来源
        handleSource(statusModel.source ?? "")

        //转发微博内容
        handleRetweet(statusModel)
        
        //会员等级
        handleMbrank(statusModel.user?.mbrank ?? 0)
        
        //认证类型
        handleVerifiedType(statusModel.user?.verified_type ?? 0)
        
        //微博正文,
        origianAttributedString = handleEmoticonContentWithStatus(statusModel.text!)
    }
    
    //微博内容,处理表情
    private func handleEmoticonContentWithStatus(status: String) -> NSAttributedString {
        //
        let temp = NSMutableAttributedString(string: status)
        
        //数组
        var matchResultArray = [WSLMatchResult]()
        
        //正则表达式,a-zA-Z0-9文字
        /*
        matchCount      匹配的个数
        matchString     匹配内容的指针
        matchRange      匹配范围的指针
        */
        (status as NSString).enumerateStringsMatchedByRegex("\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]") { (matchCount, matchString, matchRange, _) -> Void in
            //
            if let chs = matchString.memory as? String {
                //存储匹配的表情描述与表情描述对应的范围
                let matchModel = WSLMatchResult(matchString: chs, matchRange: matchRange.memory)
                
                //把模型添加到数组中
                matchResultArray.append(matchModel)
            }
        }
        
        //遍历数组
        for value in matchResultArray.reverse() {
            //从数组后面开始查找
            if let emoticon = WSLEmoticonTools.sharedTools.searchEmoticonWithArray(value.matchString) {
                //  把表情模型转成表情富文本
                //  取到表情模型里面的图片路径, 创建UIImage对象,然后让其转成富文本
                //  通过表情模型和字体对象创建表情富文本
                let attributedStr = NSAttributedString.attributedStringWithEmoticon(emoticon, font: UIFont.systemFontOfSize(14))
                
                //通过匹配的表情描述的范围替换指定表情富文本
                temp.replaceCharactersInRange(value.matchRange, withAttributedString: attributedStr)
            }
        }
        return temp
    }
    
    //认证类型等级 -1 没有认证 ，0 认证用户，2，3，5 企业认证 ， 220 达人
    private func handleVerifiedType(verifiedNum: Int){
        //
        switch verifiedNum {
        case 0:
            verifiedTypeImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedTypeImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedTypeImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedTypeImage = UIImage(named: "")
        }
    }
    
    //会员等级
    private func handleMbrank(rankNum: Int){
        //判断1-6
        if rankNum >= 1 && rankNum <= 6 {
            mbrankImage = UIImage(named: "common_icon_membership_level\(rankNum)")
        }
    }
    //微博来源处理
    private func handleSource(source: String){
        //
        if source.containsString("\">") && source.containsString("</") {
            //开始
            let startIndex = source.rangeOfString("\">")!.endIndex
            
            //结束
            let endIndex = source.rangeOfString("</")!.startIndex
            
            //获取指定范围的字符串
            let resultStr = source.substringWithRange(startIndex..<endIndex)
            
            //
            sourceContent = "来自: " + resultStr
        }
    }
    //转发微博内容
    private func handleRetweet(statusModel: WSLStatus){
        //判断是否有转发微博
        if statusModel.retweeted_status != nil {
            //取到转发内容,和转发的用户名
            guard let contentText = statusModel.retweeted_status?.text, let name = statusModel.retweeted_status?.user?.screen_name else{
                return
            }
            
            //拼接字符串
            let str = "@\(name): " + contentText
            
            retweetContent = str
            
            //处理转发微博表情
            retweetAttributedString = handleEmoticonContentWithStatus(retweetContent!)
        }
    }
    
    //处理转发,评论,赞的逻辑处理
    private func handleCount(count: Int, defaultTitle: String) -> String {
        //判断
        if count > 0 {
            //判断大于1万的时候
            if count > 10000 {
                //1w除以1k,剩余两位,
                let temp = CGFloat(count / 1000) / 10
            
                var resultStr = "\(temp)万"
                
                //判断字符串中有.0
                if resultStr.containsString(".0") {
                    resultStr = resultStr.stringByReplacingOccurrencesOfString(".0", withString: "")
                }
                return resultStr
            }else {
                return "\(count)"
            }
        } else {
            return defaultTitle
        }
    }
}
