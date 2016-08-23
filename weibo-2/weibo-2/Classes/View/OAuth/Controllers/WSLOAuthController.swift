//
//  WSLOAuthController.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking

let AppKey = "4182078967"
let AppSecret = "f14e2e9fa1488ae6ed8cdb8dac507d7b"
let Redirect_Uri = "http://www.baidu.com"

class WSLOAuthController: UIViewController {

    //webView
    private lazy var webView: UIWebView = UIWebView()
    
    //加载view
    override func loadView() {
        //改成透明
        webView.opaque = false
        
        //设置代理
        webView.delegate = self
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加取消按钮
        setupUI()
        
        //第三方登录界面
        threeOAuthLogin()
    }

    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", imageName: nil, target: self, action: "clickCancalButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", imageName: nil, target: self, action: "clickFillButton")
        navigationItem.title = "登录"
    }
    //取消按钮
    @objc private func clickCancalButton() {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //自动填充
    @objc private func clickFillButton() {
        webView.stringByEvaluatingJavaScriptFromString("document.getElementById('userId').value = '1250626642@qq.com';document.getElementById('passwd').value = '密码'")
    }

    //第三方登录界面
    private func threeOAuthLogin(){
        //url
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(AppKey)&redirect_uri=\(Redirect_Uri)"
        
        //请求
        let request = NSURLRequest(URL: NSURL(string: urlStr)!)
        
        //
        webView.loadRequest(request)
    }
}

//代理方法
extension WSLOAuthController : UIWebViewDelegate{
    //
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print(request.URL?.absoluteString)
        
        //
        guard let url = request.URL else {
            return false
        }
        
        //
        if !url.absoluteString.hasPrefix(Redirect_Uri) {
            return true
        }
        
        if let query = url.query where query.hasPrefix("code=") {
            print(query)
            
            //截取字符串
            let code = query.substringFromIndex("code=".endIndex)
            
            //
            WSLUserAccountViewModel.sharedUserAccount.requestAccessTokenWithCode(code, callBack: { (isSuccess) -> () in
                
                if isSuccess {
                    print("登录成功")
                    
                    //发送通知
                    NSNotificationCenter.defaultCenter().postNotificationName(selectRootVCNotification, object: self)
                    
                }else{
                    print("登录失败")
                }
            })
        }else {
            dismissViewControllerAnimated(true, completion: nil)
        }
        return false
        
    }
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
}
