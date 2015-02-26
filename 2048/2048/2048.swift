//
//  2048.swift
//  2048
//
//  Created by aoi on 15/2/24.
//  Copyright (c) 2015年 cezr. All rights reserved.
//

import Foundation
import UIKit

class Game: UIView {
    
    // 坐标
    var Coordinates:[[CGPoint]] = []
    var 边长:CGFloat = 0
    var 间距:CGFloat = 0
    
    // 
    var Tiles:[[TileView?]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 棕色背景
        self.backgroundColor = UIColor(red: 150/255.0, green: 100/255.0, blue: 50/255.0, alpha: 1)
        
        println("cezr")
        
        边长 = self.frame.size.width * 0.23
        间距 = (self.frame.size.width - 边长*4) / 5
        
        
        for var y:CGFloat=0; y<4; y++ {
            var _Tiles:[TileView?] = []
            var _Coordinates:[CGPoint] = []
            for var x:CGFloat=0; x<4; x++ {
                _Tiles.append(nil)
                _Coordinates.append(CGPointMake(间距 + (间距+边长)*x, 间距 + (间距+边长)*y))
                var vi:UIView = UIView(frame: CGRectMake(间距 + (间距+边长)*x, 间距 + (间距+边长)*y, 边长, 边长))
                vi.backgroundColor = UIColor(red: 52/255.0, green: 56/255.0, blue: 58/255.0, alpha: 1)
                self.addSubview(vi)
            }
            Tiles.append(_Tiles)
            Coordinates.append(_Coordinates)
        }
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func createTile(p:(y:Int,x:Int), num:Int) -> TileView {
        var tile = TileView(frame: CGRectMake(Coordinates[p.y][p.x].x, Coordinates[p.y][p.x].y, 边长, 边长))
        tile.num = num
        self.addSubview(tile)
        
        Tiles[p.y][p.x] = tile
        
        tile.amCreate()
        
        return tile
    }
    func delTile(pt:(y:Int,x:Int)) {
        var tile = Tiles[pt.y][pt.x]!
        self.Tiles[pt.y][pt.x] = nil
        
        tile.amDelete()
    }
    
    // 移动、合并
    
    func move(p1:(y:Int,x:Int), to p2:(y:Int,x:Int)) {
        var tile = Tiles[p1.y][p1.x]!
        Tiles[p2.y][p2.x] = tile
        Tiles[p1.y][p1.x] = nil
        
        var cod = Coordinates[p2.y][p2.x]
        
        tile.amMove(cod)
    }
    
    func merger(p1:(y:Int,x:Int), to p2:(y:Int,x:Int)) {
        println("合并")
        
        var tile = Tiles[p1.y][p1.x]!
        var toTile = Tiles[p2.y][p2.x]
        
        Tiles[p1.y][p1.x] = nil
        
        
        
        Tiles[p2.y][p2.x] = createTile((p2.y,p2.x), num: tile.num*2)
        
        
        
        var cod1 = tile.frame.origin
        var cod2 = Coordinates[p2.y][p2.x]
        
       // var newtile = TileView(frame: CGRectMake(Coordinates[p2.y][p2.x].x, Coordinates[p2.y][p2.x].y, 边长, 边长))
        //Tiles[p2.y][p2.x] = newtile
        
        tile.amMerger(cod2, totile: toTile!) { () -> Void in
            //self.addSubview(newtile)
            //newtile.amCreate()
        }
        
    }
    
    func test() {
        for var y:Int=0; y<4; y++ {
            for var x:Int=0; x<4; x++ {
                if Tiles[y][x] == nil {
                    print("0 ")
                }
                else {
                    print("\(Tiles[y][x]!.num) ")
                }
            }
            println()
        }
    }
    
}


















