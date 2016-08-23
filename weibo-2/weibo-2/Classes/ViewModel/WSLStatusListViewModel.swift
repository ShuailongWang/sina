//
//  WSLStatusListViewModel.swift
//  weibo-2
//
//  Created by czbk on 16/8/12.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//数据,tableView
class WSLStatusListViewModel: NSObject {
    //数据数组
    lazy var statusList: [WSLStatusViewModel] = [WSLStatusViewModel]()
    
    //加载首页数据
    func loadData(isPull: Bool, callBack: (isSuccess: Bool, message: String) -> ()){
        //上啦加载所需要的参数
        var maxID: Int64 = 0
        
        //下拉刷新所需要的参数
        var sinceId: Int64 = 0
        
        //判断参数要从哪里开始
        if isPull {
            //上啦加载获取最后一条id
            maxID = statusList.last?.statusModel?.id ?? 0
            
            //避免重复数据,
            if maxID > 0 {
                maxID -= 1
            }
        } else {
            //第一条数据
            sinceId = statusList.first?.statusModel?.id ?? 0
        }
        
        WSLStatusDAL.loadData(maxID, sinceId: sinceId) { (dictArray) -> () in

            //数组
            var arrayM = [WSLStatusViewModel]()
            for value in dictArray {
                //字典转模型
                let model = WSLStatus(dict: value)
                
                //类型转换
                let statusViewModel = WSLStatusViewModel(statusModel: model)
                
                //
                arrayM.append(statusViewModel)
            }
            //赋值
            //self.statusList = arrayM
            if isPull {
                //追加数据,数组
                self.statusList.appendContentsOf(arrayM)
            }else{
                //插入,从0开始
                self.statusList.insertContentsOf(arrayM, at: 0)
                
            }
            
            //刷新tableView
            callBack(isSuccess: true, message: "加载了\(arrayM.count)条数据")
        }
        
    }

}
