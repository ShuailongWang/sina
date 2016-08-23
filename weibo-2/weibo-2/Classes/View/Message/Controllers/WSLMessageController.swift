//
//  WSLMessageController.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLMessageController: WSLBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLogin {
            
        }else{
            noLoginView?.updateNologinView("登录后，别人评论你的微博，发给你的消息，都会在这里收到通知", imgName: "visitordiscover_image_message")
        }
    }

}
