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
    
    // 分数
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
        }
    }
    
    
    enum MOVE{
        case UP
        case DOWN
        case LEFT
        case RIGHT
        case NULL
    }
    
    init(Game game:Game, ScoreDelegate delegate:ScoreDelegate) {
        self.game = game
        //self.viewController = viewController
        scoreDelegate = delegate
        
        
        for var y:Int=0; y<4; y++ {
            var _arr:[Int] = []
            for var x:Int=0; x<4; x++ {
                _arr.append(0)
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
    
    var newtile = false
    
    
    func over() -> Bool {
        
        
        return false
    }
    
    
    func up() {
        for (var x = 0; x < 4; x++) {
            var h = 0;
            for (var y = 1; y < 4; y++) {
                if (arr[y][x] == 0)	{
                    continue;
                }
                for (var s = h; s < y; s++) {
                    if (arr[s][x] == 0) {
                        
                        
                        arr[s][x] = arr[y][x]
                        arr[y][x] = 0
                        game?.move((y,x), to: (s,x))
                        
                        newtile = true
                        h--
                        break
                    }
                    if (arr[s][x] == arr[y][x]) {
                        
                        arr[s][x] *= 2
                        arr[y][x] = 0
                        game?.merger((y,x), to: (s,x))
                        
                        current += arr[s][x]
                        
                        newtile = true
                        break
                    }
                }
                h++
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
                for (var s = h; s > y; s--) {
                    if (arr[s][x] == 0) {
                        arr[s][x] = arr[y][x]
                        arr[y][x] = 0
                        game?.move((y,x), to: (s,x))
                        newtile = true
                        h++
                        break
                    }
                    if (arr[s][x] == arr[y][x]) {
                        arr[s][x] *= 2
                        arr[y][x] = 0
                        game?.merger((y,x), to: (s,x))
                        current += arr[s][x]
                        newtile = true
                        break
                    }
                }
                h--
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
                for (var s = h; s < x; s++) {
                    if (arr[y][s] == 0) {
                        arr[y][s] = arr[y][x]
                        arr[y][x] = 0
                        game?.move((y,x), to: (y,s))
                        newtile = true
                        h--
                        break
                    }
                    if (arr[y][s] == arr[y][x]) {
                        arr[y][s] *= 2
                        arr[y][x] = 0
                        game?.merger((y,x), to: (y,s))
                        current += arr[y][s]
                        newtile = true
                        break
                    }
                }
                h++
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
                for (var s = h; s > x; s--) {
                    if (arr[y][s] == 0) {
                        arr[y][s] = arr[y][x]
                        arr[y][x] = 0
                        game?.move((y,x), to: (y,s))
                        newtile = true
                        h++
                        break
                    }
                    if (arr[y][s] == arr[y][x]) {
                        arr[y][s] *= 2
                        arr[y][x] = 0
                        game?.merger((y,x), to: (y,s))
                        current += arr[y][s]
                        newtile = true
                        break
                    }
                }
                h--
            }
        }
    }
    
    
    
}