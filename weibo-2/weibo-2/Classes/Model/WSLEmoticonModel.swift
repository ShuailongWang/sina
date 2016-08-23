//
//  WSLEmoticonModel.swift
//  weibo-2
//
//  Created by czbk on 16/8/18.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLEmoticonModel: NSObject {
    
    var chs: String?        //表情描述,发送到后台,让其识别表情的字段
    var png: String?        //图片
    var type: String?       //表情类型,0 图片 1 emoji(16禁止)
    
    var code: String?       //16进制的emoji表情字符串
    
    var path: String?       //图片的全路径,具体
    
    //
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    //防止崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
