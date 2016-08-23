//
//  WSLMainController.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLMainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置选中颜色,默认是蓝色
        UITabBar.appearance().tintColor = UIColor.orangeColor()

        //添加子控制器
        addChildViewController(WSLHomeController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(WSLMessageController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(WSLDiscoverController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(WSLMeController(), title: "我", imageName: "tabbar_profile")
        
        //自定义tabBar
        let wslTabBar = WSLMainTabBar()
        
        //设置代理
        wslTabBar.wslDelegate = self
        
        //赋值
        setValue(wslTabBar, forKey: "tabBar")
    }

    
    //重载添加子控制器
    func addChildViewController(childController: UIViewController,title: String, imageName: String) {
        //设置图片
        childController.tabBarItem.image = UIImage(named: imageName)
        //设置选中图片,渲染模式
        childController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //设置标题
        childController.title = title
        
        //设置tabBar文字颜色
        childController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], forState: UIControlState.Selected)
        //设置文字大小
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)], forState: .Normal)
        
        //添加到导航控制器
        let nav = UINavigationController(rootViewController: childController)
        
        //添加到子控制器上
        addChildViewController(nav)
    }

}

//中间加号按钮的代理事件
extension WSLMainController : WSLMainTabBarDelegate{
    func clickCenterButtonDelegate() {
        //创建控制器
        let sendVC = WSLSendWeiboViewController()
        
        //导航
        let navVC = UINavigationController(rootViewController: sendVC)
        
        //
        presentViewController(navVC, animated: true, completion: nil)
    }
}
