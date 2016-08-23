//
//  UITabBarButton+Extension.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(title: String?, imageName: String?, target: AnyObject?, action: Selector) {
        self.init()
        
        let button = UIButton()
        
        //添加事件
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        //设置图片
        button.setImage(UIImage(named: imageName ?? ""), forState: .Normal)
        button.setImage(UIImage(named: imageName ?? "" + "_highlighted"), forState: .Highlighted)
        
        //设置文字
        button.setTitle(title, forState: .Normal)
        
        //文字颜色
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)        //默认
        button.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)     //高亮
        
        //文字字号
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        //按钮大小
        button.sizeToFit()
        
        
        customView = button
    }
}
