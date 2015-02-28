//
//  GameControl.swift
//  2048
//
//  Created by aoi on 15/2/24.
//  Copyright (c) 2015年 cezr. All rights reserved.
//

import Foundation

protocol ScoreDelegate{
    func setCurrent(num:Int)
    func setHighest(num:Int)
    
    func gameOver()
}


class GameControl {
    
    var game:Game?
    var scoreDelegate:ScoreDelegate?
    
    
    var arr:[[Int]] = []
    
    /**
        分数
    */
    var current:Int = 0 {
        didSet {
            scoreDelegate?.setCurrent(current)
            if current > highest {
                highest = current
            }
        }
    }
    var highest:Int = 0 {
        didSet {
            scoreDelegate?.setHighest(highest)
            saveData()
        }
    }
    // 存取数据
    func saveData() {
        
        var path = NSHomeDirectory().stringByAppendingPathComponent("Documents") .stringByAppendingString("/a.txt")
        var dic = NSDictionary(object: highest, forKey: "fs")
        println(dic)
        dic.writeToFile(path, atomically: true)
    }
    func readData() {
        var path = NSHomeDirectory().stringByAppendingPathComponent("Documents") .stringByAppendingString("/a.txt")
        var dic = NSDictionary(contentsOfFile: path)
        println(dic)
        if dic != nil {
            highest = Int(dic!.valueForKey("fs")!.intValue)
        }
    }
    
    
       
    
    
    init(Game game:Game, ScoreDelegate delegate:ScoreDelegate) {
        self.game = game
        scoreDelegate = delegate
        readData()
        
        
 /*       var a = [
            [0,2,4,8],
            [16,32,64,128],
            [256,512,1024,2048],
            [0,0,0,0]
        ]*/
        
        
        for var y:Int=0; y<4; y++ {
            var _arr:[Int] = []
            for var x:Int=0; x<4; x++ {
                _arr.append(0)
              /*  _arr.append(a[y][x])
                game.createTile((y,x), num: a[y][x])*/
            }
            arr.append(_arr)
        }
        newTile()
        newTile()
        
        test()
    }
    
    // 重置，重新开始
    func reset() {
        for var y:Int=0; y<4; y++ {
            for var x:Int=0; x<4; x++ {
                if arr[y][x] != 0 {
                    arr[y][x] = 0
                    game?.delTile((y,x))
                }
            }
        }
        newTile()
        newTile()
        current = 0
        
        
        test()
    }
    
    func newTile() ->Bool {
        var nulls : [(y:Int,x:Int)] = []
        for var y:Int=0; y<4; y++ {
            for var x:Int=0; x<4; x++ {
                if arr[y][x] == 0 {
                    let yx = (y:y, x:x)
                    nulls.append(yx)
                }
            }
        }
        if nulls.count == 0 {
            return false
        }
        
        let yx = nulls[Int(arc4random_uniform(UInt32(nulls.count)))]
        
        arr[yx.y][yx.x] = 2
        var tile = game!.createTile((yx.y,yx.x), num: 2)
        
        return true
    }
    
    
    func test() {
        for var y:Int=0; y<4; y++ {
            for var x:Int=0; x<4; x++ {
                if arr[y][x] == 0 {
                    print("0 ")
                }
                else {
                    print("\(arr[y][x]) ")
                }
            }
            println()
        }
        println()
        
        game?.test()
        
        println()
        println()
    }
    
    enum MOVE{
        case UP
        case DOWN
        case LEFT
        case RIGHT
        case NULL
    }
    
    var newtile = false
    
    func move(move:MOVE) {
        switch move {
        case .UP:
            up()
        case .DOWN:
            down()
        case .LEFT:
            left()
        case .RIGHT:
            right()
        case .NULL:
            return
        default:
            println()
        }
        if newtile {
            if !newTile() {
                // game over
                scoreDelegate?.gameOver()
            }
            newtile = false
        }
        test()
    }
    
    func up() {
        for (var x = 0; x < 4; x++) {
            var h = 0;
            for (var y = 1; y < 4; y++) {
                if (arr[y][x] == 0)	{
                    continue;
                }
                for (; h < y; h++) {
                    if (arr[h][x] == 0) {
                        arr[h][x] = arr[y][x]
                        arr[y][x] = 0
                        game?.move((y,x), to: (h,x))
                        newtile = true
                        break
                    }
                    if (arr[h][x] == arr[y][x]) {
                        arr[h][x] *= 2
                        arr[y][x] = 0
                        game?.merger((y,x), to: (h,x))
                        current += arr[h][x]
                        h++
                        newtile = true
                        break
                    }
                }
            }
        }
    }
    func down() {
        for (var x = 0; x < 4; x++) {
            var h = 3;
            for (var y = 2; y >= 0; y--) {
                if (arr[y][x] == 0)	{
                    continue;
                }
                for (; h > y; h--) {
                    if (arr[h][x] == 0) {
                        arr[h][x] = arr[y][x]
                        arr[y][x] = 0
                        game?.move((y,x), to: (h,x))
                        newtile = true
                        break
                    }
                    if (arr[h][x] == arr[y][x]) {
                        arr[h][x] *= 2
                        arr[y][x] = 0
                        game?.merger((y,x), to: (h,x))
                        current += arr[h][x]
                        h--
                        newtile = true
                        break
                    }
                }
            }
        }
    }
    func left() {
        for (var y = 0; y < 4; y++) {
            var h = 0;
            for (var x = 1; x < 4; x++) {
                if (arr[y][x] == 0)	{
                    continue;
                }
                for (; h < x; h++) {
                    if (arr[y][h] == 0) {
                        arr[y][h] = arr[y][x]
                        arr[y][x] = 0
                        game?.move((y,x), to: (y,h))
                        newtile = true
                        break
                    }
                    if (arr[y][h] == arr[y][x]) {
                        arr[y][h] *= 2
                        arr[y][x] = 0
                        game?.merger((y,x), to: (y,h))
                        current += arr[y][h]
                        h++
                        newtile = true
                        break
                    }
                }
            }
        }
    }
    func right() {
        for (var y = 0; y < 4; y++) {
            var h = 3;
            for (var x = 2; x >= 0; x--) {
                if (arr[y][x] == 0)	{
                    continue;
                }
                for (; h > x; h--) {
                    if (arr[y][h] == 0) {
                        arr[y][h] = arr[y][x]
                        arr[y][x] = 0
                        game?.move((y,x), to: (y,h))
                        newtile = true
                        break
                    }
                    if (arr[y][h] == arr[y][x]) {
                        arr[y][h] *= 2
                        arr[y][x] = 0
                        game?.merger((y,x), to: (y,h))
                        current += arr[y][h]
                        h--
                        newtile = true
                        break
                    }
                }
            }
        }
    }
    
    
    
}