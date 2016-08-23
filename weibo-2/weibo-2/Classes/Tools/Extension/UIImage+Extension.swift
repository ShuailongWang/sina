//
//  UIImage+Extension.swift
//  weibo-2
//
//  Created by czbk on 16/8/17.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

extension UIImage {
    
    //等比压缩图片
    func scaleImageWithScaleWith(scaleWidth: CGFloat) -> UIImage {
        //压缩的高度
        let scaleHeight = scaleWidth / self.size.width * self.size.height
        
        //size
        let size = CGSize(width: scaleWidth, height: scaleHeight)
        
        //开启图片上下文
        UIGraphicsBeginImageContext(size)
        
        //图片绘制到指定区域内
        self.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        //获取图片上下文中的图片
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return scaleImage
    }

}
