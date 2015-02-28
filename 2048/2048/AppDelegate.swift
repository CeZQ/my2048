//
//  AppDelegate.swift
//  2048
//
//  Created by aoi on 15/2/24.
//  Copyright (c) 2015年 cezr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeiboSDKDelegate {

    var window: UIWindow?
    
    
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp("4133137512")
        
        
        readToken()
        
        return true
    }
    
    /*
        微博SDK
    */
    
    var token:String?
    var userID:String?
    
    func saveToken() {
        var path = NSHomeDirectory().stringByAppendingPathComponent("Documents") .stringByAppendingString("/token.txt")
        var dic = NSMutableDictionary(capacity: 2)//NSDictionary(objects: [token, userID], forKeys: ["token", "userID"])
        dic.setValue(token, forKey: "token")
        dic.setValue(userID, forKey: "userID")
        println(dic)
        dic.writeToFile(path, atomically: true)
    }
    func readToken() {
        var path = NSHomeDirectory().stringByAppendingPathComponent("Documents") .stringByAppendingString("/token.txt")
        var dic = NSDictionary(contentsOfFile: path)
        println(dic)
        if dic == nil {
            return
        }
        token = String(dic?.valueForKey("token") as NSString)
        userID = String(dic?.valueForKey("userID") as NSString)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return WeiboSDK.handleOpenURL(url, delegate: self)
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WeiboSDK.handleOpenURL(url, delegate: self)
    }
    
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
    }
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        if response.isKindOfClass(WBAuthorizeResponse.classForCoder()) {
            var wb = response as WBAuthorizeResponse
            token = wb.accessToken
            userID = wb.userID
            saveToken()
        }
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

