//
//  WSLUserModel.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLUserModel: NSObject {
    var id: Int64 = 0                   //用户id
    var screen_name: String?            //用户名
    var profile_image_url: String?      //用户头像
    var verified_type: Int = 0          //用户认证类型等级 -1 没有认证 ，0 认证用户，2，3，5 企业认证 ， 220 达人
    var mbrank: Int = 0                 //用户会员等级 1-6
    
    //便利构造方法
    init(dict: [String: AnyObject]){
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    //防止崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
