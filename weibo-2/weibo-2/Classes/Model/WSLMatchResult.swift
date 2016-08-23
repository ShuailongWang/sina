//
//  WSLMatchResult.swift
//  weibo-2
//
//  Created by czbk on 16/8/20.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//匹配表情描述
//表情描述
class WSLMatchResult: NSObject {
    
    var matchString: String     //表情描述
    var matchRange: NSRange     //表情描述
    
    //
    init(matchString: String, matchRange: NSRange) {
        self.matchString = matchString
        self.matchRange = matchRange
        
        super.init()
    }
}
