//
//  ViewController.swift
//  2048
//
//  Created by aoi on 15/2/24.
//  Copyright (c) 2015年 cezr. All rights reserved.
//

import UIKit



class ViewController: UIViewController, ScoreDelegate, UIAlertViewDelegate {
    
    var gameControl:GameControl?
    
    
//    var buttonStart:UIButton?
    
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
        //current = 0
    }
    
    
    // 存取数据
    //var data:Dictionary<String, Int> = []
    
    func saveData() {
       
    }
    func readData() {
        
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
    
    func initializationScores() {
        Current.text = "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 移动
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

