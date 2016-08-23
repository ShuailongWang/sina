//
//  WSLPictureModel.swift
//  weibo-2
//
//  Created by czbk on 16/8/13.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLPictureModel: NSObject {

    var thumbnail_pic: String?  //图片
    
    //kvc
    init(dict: [String: AnyObject]){
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    //防止崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
