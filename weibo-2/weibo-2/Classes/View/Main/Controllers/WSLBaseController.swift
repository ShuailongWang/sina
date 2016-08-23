//
//  WSLBaseController.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLBaseController: UITableViewController {
    //登录标记
    var isLogin: Bool = WSLUserAccountViewModel.sharedUserAccount.isLogin
    
    //未登录视图
    var noLoginView: WSLNoLoginView?
    
    //页面加载
    override func loadView() {
        if isLogin {
            super.loadView()
        } else {
            //没有的登录的时候,显示
            noLoginView = WSLNoLoginView()
            noLoginView?.clickNologinButton = {
                print("中间的登录与注册")
                self.threeOAuthVC()
            }
            
            //当前view = noLoginView
            view = noLoginView
            
            //导航条上面的登录注册按钮
            setNavButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func setNavButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", imageName: nil, target: self, action: "clcickLeftButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", imageName: nil,  target: self, action: "clickRightButton")
        
    }
    
    //登录,注册点击事件
    @objc private func clcickLeftButton(){
        print("注册")
        threeOAuthVC()
    }
    @objc private func clickRightButton(){
        print("登录")
        threeOAuthVC()
    }
    
    private func threeOAuthVC() {
        let oauthVC = WSLOAuthController()
        
        let nav = UINavigationController(rootViewController: oauthVC)
        
        presentViewController(nav, animated: true, completion: nil)
    }
}
