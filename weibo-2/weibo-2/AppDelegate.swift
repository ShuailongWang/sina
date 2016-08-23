//
//  AppDelegate.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectRootVC:", name: selectRootVCNotification, object: nil)
        
        //1,创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //2,创建控制器
        let rootVC = WSLMainController()
        
        //3,设置根视图
        window?.rootViewController = rootVC
        
        //4,设置窗口并可见
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func selectRootVC(nsnotification: NSNotification) {
        if nsnotification.object is WSLOAuthController {
            window?.rootViewController = WSLWecomeController()
        }else{
            window?.rootViewController = WSLMainController()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

