//
//  WSLSqliteManager.swift
//  weibo-2
//
//  Created by czbk on 16/8/21.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//数据库名称
let DBName = "SinaWeibo.db"

//数据库储存的沙盒路径
let DBPath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent(DBName)

//
class WSLSqliteManager: NSObject {
    //单例全局访问点
    static let sharedManager: WSLSqliteManager = WSLSqliteManager()
    
    //数据库操作队列
    lazy var queue = FMDatabaseQueue(path: DBPath)
    
    //构造函数私有化
    private override init() {
        super.init()
        //创建表
        createTables()
    }
    //  通过查询sql语句返回数组字典
    func queryDicArrayForSql(sql: String) -> [[String: AnyObject]] {
        
        var tempArray = [[String: AnyObject]]()
        queue.inDatabase { (db) -> Void in
            let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
            //  遍历结果集,判断是否有下一条记录
            while resultSet.next() {
                
                //  获取列数
                let cols = resultSet.columnCount()
                
                var dic = [String: AnyObject]()
                //  遍历列数
                for i in 0..<cols {
                    
                    //  获取列名
                    let colName = resultSet.columnNameForIndex(i)
                    //  获取列名对应的值
                    let colValue = resultSet.objectForColumnIndex(i)
                    //resultSet.objectForColumnName(colName)
                    
                    //dic.updateValue(<#T##value: Value##Value#>, forKey: <#T##Hashable#>)
                    //  添加键值对
                    dic[colName] = colValue
                }
                
                tempArray.append(dic)
                
            }
            
        }
        
        return tempArray
        
    }
    
    //修改数据
    func update() {
        //
        let sql = "update T_PERSON set name = ? where id = ?"
        
        //
        queue.inDatabase { (db) -> Void in
            //执行sql语句
            //withArgumentsInArray
            let result = db.executeUpdate(sql, withArgumentsInArray: ["赵丽颖", 22])
            
            //
            if result {
                print("修改成功")
            }else{
                print("修改失败")
            }
        }
    }
    
    //查询数据
    func selectData(){
        //sql语句
        let sql = "select id, name, age from T_PERSON"
        
        //执行查询操作
        queue.inDatabase { (db) -> Void in
            //执行select
            //
            let result = db.executeQuery(sql, withArgumentsInArray: nil)
            
            //
            while result.next() {
                //获取id
                let id = result.intForColumn("ID")
                
                //获取name
                let name = result.intForColumn("NAME")
                
                //获取年龄
                let age = result.intForColumn("AGE")
                
                print("id: \(id), name: \(name), age:\(age)")
            }
        }
    }
    
    //插入数据
    func insertData(){
        //sql语句
        let sql = "insert into T_Person (name, age) values (?, ?)"
        
        //数据查询操作
        queue.inDatabase { (db) -> Void in
            //执行除去select之外的sql语句,
            let result = db.executeUpdate(sql, withArgumentsInArray: ["杨幂", 20])
            
            //
            if result {
                print("插入成功")
            }else{
                print("插入失败")
            }
        }
    }
    
    //创建表
    private func createTables() {
        //获取文件路径
        let path = NSBundle.mainBundle().pathForResource("db.sql", ofType: nil)
        
        //获取文件中的sql语句
        //  try! 表示文件内容没有问题, 有问题崩溃
        //  try? 表示如果有问题则不会崩溃,有问题返回nil
        let sql = try! String(contentsOfFile: path!)
        
        //执行增,删,查,改
        queue.inDatabase { (db) -> Void in
            //  执行sql语句,返回一个bool值
            //  (executeStatements连续执行多条sql语句)∫
            let result = db.executeStatements(sql)
            
            //判断是否成功
            if result {
                print("创建成功.")
            }else{
                print("创建失败.")
            }
        }
        
    }
}
