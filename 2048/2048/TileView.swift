//
//  TileView.swift
//  2048
//
//  Created by aoi on 15/2/24.
//  Copyright (c) 2015年 cezr. All rights reserved.
//

import Foundation

import UIKit

class TileView: UIView {
    
    var num:Int = 0 {
        didSet {
            image?.image = UIImage(named: "\(num)")
        }
    }
    
    //var lable:UILabel = UILabel()
    var image:UIImageView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.backgroundColor = UIColor(red: 30/255.0, green: 150/255.0, blue: 250/255.0, alpha: 1)
        
        image = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        image!.contentMode = UIViewContentMode.ScaleToFill
        self.addSubview(image!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 动画效果
    func amCreate() {
        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1)
       // image!.transform = CGAffineTransformScale(image!.transform, 0.1, 0.1)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.transform = CGAffineTransformScale(self.transform, 10, 10)
            //self.image!.transform = CGAffineTransformScale(self.image!.transform, 10, 10)
        })
    }
    func amDelete() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1)
            }) { (bool) -> Void in
                self.removeFromSuperview()
                println("rm")
        }
    }
    func amMove(pt:CGPoint) {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.transform = CGAffineTransformTranslate(self.transform, pt.x-self.frame.origin.x, pt.y-self.frame.origin.y)
        })
    }
    func amMerger(pt:CGPoint, totile:TileView, fun:()->Void) {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.transform = CGAffineTransformTranslate(self.transform, pt.x-self.frame.origin.x, pt.y-self.frame.origin.y)
        }) { (bool) -> Void in
            self.removeFromSuperview()
            totile.removeFromSuperview()
            fun()
        }
    }
    
}