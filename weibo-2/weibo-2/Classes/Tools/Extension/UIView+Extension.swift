//
//  UIView+Extension.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

extension UIView {
    //x
    var x: CGFloat {
        get{
            return frame.origin.x
        }
        set{
            frame.origin.x = newValue
        }
    }
    
    //y
    var y: CGFloat {
        get{
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    //width
    var width: CGFloat {
        get{
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    //height
    var height: CGFloat {
        get{
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    //size
    var size: CGSize {
        get{
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
    
    //centerX
    var centerX: CGFloat {
        get{
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    //centerY
    var centerY: CGFloat {
        get{
            return center.y
        }
        set {
            center.y = newValue
        }
    }

}
