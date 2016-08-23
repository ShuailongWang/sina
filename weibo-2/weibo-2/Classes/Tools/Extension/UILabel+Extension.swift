//
//  UILabel+Extension.swift
//  weibo-2
//
//  Created by czbk on 16/8/12.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(fontSize: CGFloat, textColor: UIColor){
        self.init()
        
        //
        self.font = UIFont.systemFontOfSize(14)
        self.textColor = textColor
    }
}
