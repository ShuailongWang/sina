//
//  WSLUserAccount.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLUserAccount: NSObject, NSCoding {
    //MARK: access_token中的字段
    var access_token: String?//用户授权的唯一票据
    
    //access_token的生命周期，单位是秒数。
    var expires_in: NSTimeInterval = 0 {
        didSet{
            //过期时间 = 获取accesstoken那一刻的时间 + 过期秒数
            expiresDate = NSDate().dateByAddingTimeInterval(expires_in)
        }
    }
    //过期时间
    var expiresDate: NSDate?
    
    //授权用户的id
    var uid: Int64 = 0
    var name: String?
    var avatar_large: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    //归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeInt64(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    //解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid  = aDecoder.decodeInt64ForKey("uid")
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    //保存到沙盒路径
    func saveUserAccount(){
        //路径
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "userAccount.archive"
        
        //执行归档
        NSKeyedArchiver.archiveRootObject(self, toFile: path)
    }
    
    //类函数,解档
    class func loadUserAccount() -> WSLUserAccount? {
        //路径
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "userAccount.archive"
        
        //解档
        return NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? WSLUserAccount
    }
}























