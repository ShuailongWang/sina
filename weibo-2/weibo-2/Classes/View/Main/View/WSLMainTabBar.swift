//
//  WSLMainTabBar.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

protocol WSLMainTabBarDelegate: NSObjectProtocol {
    func clickCenterButtonDelegate()
}

class WSLMainTabBar: UITabBar {
    //代理属性
    weak var wslDelegate: WSLMainTabBarDelegate?
    
    //懒加载,控件
    private lazy var centerButton: UIButton = {
        let button = UIButton()
        
        //添加点击事件
        button.addTarget(self, action: "clickCenterButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        //设置button
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Highlighted)
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: .Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: .Highlighted)
        
        //大小
        button.sizeToFit()
        
        return button
    }()
    
    //按钮点击事件
    @objc private func clickCenterButton(){
        //print("++")
        
        //代理
        wslDelegate?.clickCenterButtonDelegate()
    }

    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加按钮
        addSubview(centerButton)
    }
    //xib
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //设置按钮的位置
        centerButton.centerX = width/2
        centerButton.centerY = height/2
        
        //设置tabBar上面其它的按钮
        let itemWidth = width / 5  //每一个的宽度
        var index = 0              //索引
        
        //遍历子控件
        for value in subviews {
            //判断是UITabBarButton
            if value.isKindOfClass(NSClassFromString("UITabBarButton")!) {
                //是的话,布局
                value.width = itemWidth
                value.x = CGFloat(index) * itemWidth
                
                index++
                
                //判断,把中间隔开,方加号按钮
                if index == 2 {
                    index++
                }
            }
        }
    }
    
}
