//
//  WSLNewworkTools.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestType {
    case GET
    case POST
}

class WSLNewworkTools: AFHTTPSessionManager {
    //单例
    static let sharedTools: WSLNewworkTools = {
        let tools = WSLNewworkTools()
        
        //
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
    
    //封装get,post
    func request(type: RequestType, url: String, bodys: AnyObject?, callBack: (response: AnyObject?, error: NSError?)->()){
        if type == .GET {
            GET(url, parameters: bodys, progress: nil, success: { (_, reponst) -> Void in
                    callBack(response: reponst, error: nil)
                }, failure: { (_, error) -> Void in
                    callBack(response: nil, error: error)
            })
        }else{
            POST(url, parameters: bodys, progress: nil, success: { (_, reponst) -> Void in
                    callBack(response: reponst, error: nil)
                }, failure: { (_, error) -> Void in
                    callBack(response: nil, error: error)
            })
        }
    }
   
    //封装上传图片的接口
    func requestPicture(url: String, bodys: AnyObject?, imageData: NSData, name: String, callBack: (response: AnyObject?, error: NSError?)->()){
        //
        POST(url, parameters: bodys, constructingBodyWithBlock: { (formData) -> Void in
            //  data 图片对应的二进制数据
            //  name 服务端需要参数
            //  fileName 图片对应名字,一般服务不会使用,因为服务端会直接根据你上传的图片随机产生一个唯一的图片名字
            //  mimeType 资源类型
            //  不确定参数类型 可以这个 octet-stream 类型, 二进制流
            formData.appendPartWithFileData(imageData, name: name, fileName: "test", mimeType: "application/octet-stream")
            
            }, progress: nil, success: { (_, reponse) -> Void in
                callBack(response: reponse, error: nil)
            }) { (_, error) -> Void in
                callBack(response: nil, error: error)
        }
    }

}

//发送微博接口
extension WSLNewworkTools {
    //文字微博
    func send(accessToken: String, status: String, callBack: (response: AnyObject?, error: NSError?)->()){
        //url
        let urlStr = "https://api.weibo.com/2/statuses/update.json"
        
        //参数
        let httpBody = [
            "access_token": accessToken,
            "status": status
        ]
        
        //请求
        request(.POST, url: urlStr, bodys: httpBody, callBack: callBack)
    }
    
    //文字+图片(1张)
    func sendPicture(accessToken: String, status: String, image: UIImage, callBack: (response: AnyObject?, error: NSError?)->()){
        //url
        let urlStr = "https://upload.api.weibo.com/2/statuses/upload.json"
        
        
        //参数
        let httpBody = [
            "access_token": accessToken,
            "status": status
        ]
        
        //把图片转换成二进制
        let imageData = UIImageJPEGRepresentation(image, 0.5)!
        //或
//        let imageData1 = UIImagePNGRepresentation(image)上面的比这个缩小10倍左右
        
        
        //请求
        requestPicture(urlStr, bodys: httpBody, imageData: imageData, name: "pic", callBack: callBack)
        
    }
}

//首页数据
extension WSLNewworkTools {
    //获取当前登录用户及其所关注用户的最新微博(授权)
    func requestStatus(accessToken: String, maxId: Int64, sinceId: Int64, callBack: (response: AnyObject?, error: NSError?)->()){
        //url
        let urlStr = "https://api.weibo.com/2/statuses/friends_timeline.json"
        
        //参数
        let httpBody = [
            "access_token": accessToken,
            "max_id": "\(maxId)",
            "since_id": "\(sinceId)"
        ]
        
        let path = urlStr + "?access_token=" + accessToken
        print(path)
        
        request(.GET, url: urlStr, bodys: httpBody, callBack: callBack)
    }
}

//登录接口
extension WSLNewworkTools {
    //通过code获取accessToken
    func requestAccessTokenWithCode(code: String, callBack: (response: AnyObject?, error: NSError?)->()){
        //url
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        
        //参数
        let httpBody = [
            "client_id":AppKey,
            "client_secret": AppSecret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Redirect_Uri
        ]
        request(.POST, url: urlStr, bodys: httpBody, callBack: callBack)
    
    }
    
    //通过accessToken和uid获取用户信息
    func requestUserInfo(userAccount: WSLUserAccount, callBack: (response: AnyObject?, error: NSError?)->()){
        //url
        let urlStr = "https://api.weibo.com/2/users/show.json"
        
        //参数
        let httpBody = [
            "access_token": userAccount.access_token!,
            "uid": "\(userAccount.uid)"
        ]
        
        //
        request(.GET, url: urlStr, bodys: httpBody, callBack: callBack)
    }
}
