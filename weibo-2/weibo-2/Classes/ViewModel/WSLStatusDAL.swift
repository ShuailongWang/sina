//
//  WSLStatusDAL.swift
//  weibo-2
//
//  Created by czbk on 16/8/21.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//最后删除缓存时间
let MaxTimeInterval: NSTimeInterval = -7 * 24 * 60 * 60;

class WSLStatusDAL: NSObject {

    //处理微博首页数据
    class func loadData(maxId: Int64, sinceId: Int64, callBack: (statusDicArray: [[String: AnyObject]])->()) {
        
        //  1 判断本地是否有缓存数据(完成)
        let result = checkCacheData(maxId, sinceId: sinceId)
        //  2.如果本地有缓存数据直接返回缓存数据
        if result.count > 0 {
            callBack(statusDicArray: result)
            print("有缓存数据")
            return
        }
        //  3.如果本地没有缓存数据那么去网络请求微博数据
        WSLNewworkTools.sharedTools.requestStatus(WSLUserAccountViewModel.sharedUserAccount.accessToken!, maxId: maxId, sinceId: sinceId) { (response, error) -> () in
            if error != nil {
                print("网络请求异常,\(error)")
                callBack(statusDicArray: result)
                return
            }
            //  代码执行到此,表示网络请求成功
            guard let dic = response as? [String: AnyObject] else {
                print("字典格式不正确")
                callBack(statusDicArray: result)
                return
            }
            //  字典格式正确
            guard let dicArray = dic["statuses"] as? [[String: AnyObject]] else {
                print("字典格式不正确")
                callBack(statusDicArray: result)
                return
            }
            
            //  4. 网络请求成功后缓存到本地 (完成)
            //  缓存微博数据
            WSLStatusDAL.cacheData(dicArray)
            //  5. 缓存到本地成功后返回网络请求的数据
            callBack(statusDicArray: dicArray)
            print("网络下载")
        }
        
        
        
        
        
        
        
        
        
    }
    //  查询本地缓存数据
    class func checkCacheData(maxId: Int64, sinceId: Int64) -> [[String: AnyObject]] {
        //  SELECT * FROM statuses where statusid > 4010861599809739 and userid = 1800530611 order by statusid desc limit 20
        //  准备sql
        var sql = "SELECT * FROM statuses\n"
        
        if maxId > 0 {
            //  上拉加载
            sql += "where statusid < \(maxId)\n"
        } else {
            //  下拉刷新
            sql += "where statusid > \(sinceId)\n"
        }
        //  拼接userid
        sql += "and userid = \(WSLUserAccountViewModel.sharedUserAccount.userAccount!.uid)\n"
        //  排序方式
        sql += "order by statusid desc\n"
        //  最大获取数量
        sql += "limit 20\n"
        
        
        let result = WSLSqliteManager.sharedManager.queryDicArrayForSql(sql)
        var tempArray = [[String: AnyObject]]()
        for value in result {
            //  获取微博二进制数据
            let statusData = value["status"]! as! NSData
            //  通过微博二进制数据转成微博字典
            let statusDic = try! NSJSONSerialization.JSONObjectWithData(statusData, options: []) as! [String: AnyObject]
            tempArray.append(statusDic)
        }
        
        return tempArray
        
        
        
        
        
    }
    
    
    //  缓存微博数据
    class func cacheData(statusDicArray: [[String: AnyObject]]) {
        //  准备sql
        let sql = "INSERT OR Replace INTO statuses (statusid, status, userid) VALUES (?, ?, ?)"
        //  用户id
        let userid = WSLUserAccountViewModel.sharedUserAccount.userAccount!.uid
        //  执行sql语句
        WSLSqliteManager.sharedManager.queue.inTransaction { (db, rollBack) -> Void in
            //  遍历微博字典数组插入数据
            for statusDic in statusDicArray {
                //  微博id
                let id = statusDic["id"]!
                //  微博内容
                let statusDicData = try! NSJSONSerialization.dataWithJSONObject(statusDic, options: [])
                let result = db.executeUpdate(sql, withArgumentsInArray: [id, statusDicData, "\(userid)"])
                
                if result == false {
                    //  如果出现异常让事务回滚
                    rollBack.memory = true
                    break
                }
                
                
            }
            
            
        }
        
        
    }
    
    
    //  清除缓存数据
    class func clearCacheData() {
        
        
        let date = NSDate().dateByAddingTimeInterval(MaxTimeInterval)
        let dt = NSDateFormatter()
        dt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dt.locale = NSLocale(localeIdentifier: "en_US")
        //  获取时间字符串
        let dtStr = dt.stringFromDate(date)
        
        //  准备sql语句
        let sql = "Delete FROM statuses where time < '\(dtStr)'"
        //  执行sql语句
        WSLSqliteManager.sharedManager.queue.inDatabase { (db) -> Void in
            let result = db.executeUpdate(sql, withArgumentsInArray: nil)
            if result {
                //  changes 这次数据操作影响的行数
                print("删除数据成功, 影响了\(db.changes())条数据")
            } else {
                print("删除数据失败")
            }
        }
        
    }
    
}
