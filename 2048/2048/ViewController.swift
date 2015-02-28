//
//  ViewController.swift
//  2048
//
//  Created by aoi on 15/2/24.
//  Copyright (c) 2015年 cezr. All rights reserved.
//

import UIKit



class ViewController: UIViewController, ScoreDelegate, UIAlertViewDelegate, WBHttpRequestDelegate {
    
    var gameControl:GameControl?
    
    
    
    // 分数
    @IBOutlet weak var Current: UILabel!
    @IBOutlet weak var Highest: UILabel!
    
    func setCurrent(num: Int) {
        Current.text = "\(num)"
    }
    func setHighest(num: Int) {
        Highest.text = "\(num)"
    }
    
    func gameOver() {
        var al = UIAlertView(title: "游戏结束", message: "游戏结束", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "重新开始")
        al.show()
        
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        println(buttonIndex)
        switch buttonIndex {
        case 1:
            gameControl?.reset()
        default:
            break
        }
    }
    
    // 重置
    @IBAction func buttonStart(sender: UIButton) {
        gameControl?.reset()
    }
    // 微博分享
    @IBAction func buttonShared(sender: AnyObject) {
        UIGraphicsBeginImageContext(self.view.bounds.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        
        var wbmessage: WBMessageObject = WBMessageObject.message() as WBMessageObject
        wbmessage.text = "测试   项目地址 https://github.com/CeZQ/my2048   "
        var wbImage = WBImageObject.object() as WBImageObject
        wbImage.imageData = UIImagePNGRepresentation(image);
        wbmessage.imageObject = wbImage;
        
        var authRequest = WBAuthorizeRequest.request() as WBAuthorizeRequest
        authRequest.redirectURI = "https://api.weibo.com/oauth2/default.html";
        authRequest.scope = "all";
        
        var app = UIApplication.sharedApplication().delegate as AppDelegate
        
        var token:String? = app.token
        
        var request = WBSendMessageToWeiboRequest.requestWithMessage(wbmessage, authInfo: authRequest, access_token: token) as WBBaseRequest
        WeiboSDK.sendRequest(request)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 灰色背景
        self.view.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1)
        
        var game = Game(frame: CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.width))
                
        self.view.addSubview(game)
        
        var gc = GameControl(Game: game, ScoreDelegate: self)
        gameControl = gc
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/**
    触摸滑动方向的判断
*/
    var point:CGPoint?
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        point = touches.anyObject()?.locationInView(self.view)
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        var newPoint = touches.anyObject()?.locationInView(self.view)
        
        // 移动的距离
        let xd = newPoint!.x - point!.x
        let yd = newPoint!.y - point!.y
        // 判定范围
        let RG:CGFloat = 30
        var 方向:GameControl.MOVE = GameControl.MOVE.NULL
        
        
        if abs(xd) < RG {
            if abs(yd) < RG {
                // 点击
                println("点击")
            }
            else if yd > 0 {
                // 下
                println("下")
                方向 = GameControl.MOVE.DOWN
            }
            else {
                // 上
                println("上")
                //gameControl?.up()
                方向 = GameControl.MOVE.UP
            }
        }
        else {
            if abs(yd) > RG {
                // 无效
                println("无效")
            }
            else if xd > 0 {
                // 右
                println("右")
                方向 = GameControl.MOVE.RIGHT
            }
            else {
                // 左
                println("左")
                方向 = GameControl.MOVE.LEFT
            }
        }
        gameControl?.move(方向)
    }

}

