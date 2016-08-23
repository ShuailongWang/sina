//
//  NSDate+Extension.swift
//  weibo-2
//
//  Created by czbk on 16/8/14.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

extension NSDate {
    
    //把返回的字符串转换成时间
    class func sinaDate (createDateStr: String) -> NSDate {
        //时间格式化对象
        let date = NSDateFormatter()
        
        //格式化方式,Sun Aug 14 16:34:58 +8888 2016
        date.dateFormat = "EEE MMM dd HH:mm:ss z yyyy"
        
        //指定本地化信息
        date.locale = NSLocale(localeIdentifier: "en_US")
        
        //通过格式化方式转化成字符串,时间对象
        let createDate = date.dateFromString(createDateStr)!
        
        return createDate
    }
    
    //
    var sinaDateStr: String {
        //格式化对象
        let date = NSDateFormatter()
        
        //本地化信息
        date.locale = NSLocale(localeIdentifier: "en_US")
        
        //判断是否是今年,调用方法,去判断是否为今年
        if isThisYear(self) {
            //日历
            let calendar = NSCalendar.currentCalendar()
            
            //判断今天
            if calendar.isDateInToday(self) {
                //获取发微博时间距离当前时间的,差多少秒
                let timeInterValue = abs(self.timeIntervalSinceNow)
                
                //
                if timeInterValue < 60 {
                    return "\(Int(timeInterValue))秒前"
                } else if timeInterValue < 3600 {
                    //获取分钟
                    let temp = timeInterValue / 60
                    
                    return "\(Int(temp))分钟前"
                } else {
                    //小时
                    let temp = timeInterValue / 3600
                    
                    return "\(Int(temp))小时前"
                }
            } else if calendar.isDateInYesterday(self) {
                //昨天
                date.dateFormat = "昨天 HH:mm"
            } else {
                //其它
                date.dateFormat = "MM-dd HH:mm"
            }
        }else {
            //不是今年
            date.dateFormat = "yyyy-MM-dd HH:mm"
        }
        
        return date.stringFromDate(self)
    }
    
    //判断是否为今年
    private func isThisYear(createDate: NSDate) -> Bool {
        let date = NSDateFormatter()
        
        //格式化方式
        date.dateFormat = "yyyy"
        
        //指定本地信息
        date.locale = NSLocale(localeIdentifier: "en_US")
        
        //获取发微博时间的年份
        let createYear = date.stringFromDate(createDate)
        
        //获取当前的年份
        let currentYear = date.stringFromDate(NSDate())
        
        //对比年份
        return createYear == currentYear
    }
    
    
}
