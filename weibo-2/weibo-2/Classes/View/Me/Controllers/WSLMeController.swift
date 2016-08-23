//
//  WSLMeController.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLMeController: WSLBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if isLogin {
            
        }else{
            noLoginView?.updateNologinView("登录后，你的微博、相册、个人资料会显示在这里，展示给别人", imgName: "visitordiscover_image_profile")
        }
    }
}
