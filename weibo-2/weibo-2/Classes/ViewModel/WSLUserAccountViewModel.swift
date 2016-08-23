//
//  WSLUserAccountViewModel.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLUserAccountViewModel: NSObject {

    //单例
    static let sharedUserAccount: WSLUserAccountViewModel = WSLUserAccountViewModel()
    
    //用户账号
    var userAccount: WSLUserAccount? {
        return WSLUserAccount.loadUserAccount()
    }
    
    //封装accessToken
    var accessToken: String? {
        guard let token = userAccount?.access_token else{
            return nil
        }
        
        let result = userAccount?.expiresDate?.compare(NSDate())
        
        if result == NSComparisonResult.OrderedDescending {
            return token
        }else {
            return nil
        }
    }
    
    //是否登录
    var isLogin: Bool {
        return accessToken != nil
    }
    
    
    //通过code获取accessToken
    func requestAccessTokenWithCode(code: String, callBack: (isSuccess: Bool)->()){
        
        //
        WSLNewworkTools.sharedTools.requestAccessTokenWithCode(code) { (response, error) -> () in
            if error != nil {
                print("网络请求失败,\(error)")
                callBack(isSuccess: false)
                return
            }
            
            guard let dict = response as? [String: AnyObject] else {
                print("不是字典格式")
                callBack(isSuccess: false)
                return
            }
            
            //字典转模型
            let userAccount = WSLUserAccount(dict: dict)
            
            //请求用户的信息
            self.requesUserInfo(userAccount, callBack: callBack)
        }
    
    }
    
    //通过accessToken和uid获取用户信息
    private func requesUserInfo(userAccount: WSLUserAccount, callBack: (isSuccess: Bool)->()){
        
        //
        WSLNewworkTools.sharedTools.requestUserInfo(userAccount) { (response, error) -> () in
            //
            if error != nil {
                print("网络请求失败,\(error)")
                callBack(isSuccess: false)
                return
            }
            
            //
            guard let dict = response as? [String: AnyObject] else {
                print("不是字典类型")
                callBack(isSuccess: false)
                return
            }
            
            //
            let name = dict["name"]
            let avatar_large = dict["avatar_large"]
            
            //
            userAccount.name = name as? String
            userAccount.avatar_large = avatar_large as? String
            
            //保存模型
            userAccount.saveUserAccount()
            
            //
            print("11->\(userAccount.name)")
            print("11->\(userAccount.avatar_large)")
            
            callBack(isSuccess: true)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
