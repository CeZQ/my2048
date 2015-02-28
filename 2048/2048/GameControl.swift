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
    // 存取分数
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
    
    // 游戏存档、读档
    func saveGame() -> Bool {
        var path = NSHomeDirectory().stringByAppendingPathComponent("Documents") .stringByAppendingString("/game.txt")
        var dic = NSMutableDictionary(capacity: 2)
        dic.setValue(arr, forKey: "arr")
        dic.setValue(current, forKey: "current")
        
/*        println(path)
        println(dic)*/
        
        if dic.writeToFile(path, atomically: true) {
            return true
        }
        return false
    }
    func readGame() ->Bool {
        var path = NSHomeDirectory().stringByAppendingPathComponent("Documents") .stringByAppendingString("/game.txt")
        var dic = NSDictionary(contentsOfFile: path)
        
        if dic == nil {
            return false
        }
        
        var _arr:[[Int]]?
        var _current:Int?
        _arr = dic!.valueForKey("arr") as? [[Int]]
        _current = dic!.valueForKey("current") as? Int
        
        current = _current!
        
        for var y:Int=0; y<4; y++ {
            for var x:Int=0; x<4; x++ {
                arr[y][x] = _arr![y][x]
                game!.createTile((y,x), num: arr[y][x])
            }
        }
        return true
    }
    
    
       
    
    
    init(Game game:Game, ScoreDelegate delegate:ScoreDelegate) {
        self.game = game
        scoreDelegate = delegate
        
        
        
        for var y:Int=0; y<4; y++ {
            var _arr:[Int] = []
            for var x:Int=0; x<4; x++ {
                _arr.append(0)
            }
            arr.append(_arr)
        }
        
        readData()
        if !readGame() {
            newTile()
            newTile()
        }
        
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
    
    // 创建新的方块
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
    
    // 打印arr
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
    
    
    /**
        移动
    */
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
            newTile()
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