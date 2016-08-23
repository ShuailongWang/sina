//
//  CommonTools.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//切换根视图的通知名
let selectRootVCNotification = "selectRootVCNotification"

//随机颜色
func randColor() -> UIColor {
    
    return UIColor(red: CGFloat(random() % 256) / 255, green: CGFloat(random() % 256) / 255, blue: CGFloat(random() % 256) / 255, alpha: 1)
}

//homeView间距
let homeViewMagin: CGFloat = 10

//屏幕的宽,高
let ScreenWidth = UIScreen.mainScreen().bounds.width
let ScreenHeight = UIScreen.mainScreen().bounds.height


//表情按钮通知名
let EmoticonNotificationName = "EmoticonNotificationName"

//表情按钮上的删除通知名
let DeleteEmoticonNotificationName = "DeleteEmoticonNotificationName"