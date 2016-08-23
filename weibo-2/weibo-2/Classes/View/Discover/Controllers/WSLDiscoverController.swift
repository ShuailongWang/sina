//
//  WSLDiscoverController.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLDiscoverController: WSLBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if isLogin {
            
        }else{
            noLoginView?.updateNologinView("登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过", imgName: "visitordiscover_image_message")
        }
    }
}
