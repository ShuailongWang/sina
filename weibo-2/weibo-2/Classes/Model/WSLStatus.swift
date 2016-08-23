//
//  WSLStatus.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLStatus: NSObject {
    
    var created_at: String?         //  发微博时间
    var id: Int64 = 0               //  微博id
    var text: String?               //  微博内容
    var source: String?             //  来源
    var user: WSLUserModel?         //  关注用户的模型
    var reposts_count: Int = 0      //  转发数
    var comments_count:	Int = 0     //  评论数
    var attitudes_count: Int = 0    //	表态数
    
    var retweeted_status: WSLStatus?    //  转发微博
    var pic_urls: [WSLPictureModel]?    //  图片
    
    //字典转模型
    init(dict: [String: AnyObject]){
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    //当遇到user的时候重新赋值,
    override func setValue(value: AnyObject?, forKey key: String) {
        //判断user
        if key == "user" {
            guard let dic = value as? [String: AnyObject] else {
                return
            }
            user = WSLUserModel(dict: dic)
            
        }else if key == "pic_urls"{
            guard let dicArray = value as? [[String: AnyObject]] else {
                return
            }
            
            var arrayM = [WSLPictureModel]()
            for num in dicArray{
                let picModel = WSLPictureModel(dict: num)
                
                arrayM.append(picModel)
            }
            pic_urls = arrayM
            
        }else if key == "retweeted_status"{
            guard let dic = value as? [String: AnyObject] else {
                return
            }
            retweeted_status = WSLStatus(dict: dic)
            
        } else{
            super.setValue(value, forKey: key)
        }
    }
    
    //防止崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
