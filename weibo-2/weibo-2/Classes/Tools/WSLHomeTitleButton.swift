//
//  WSLHomeTitleButton.swift
//  weibo-2
//
//  Created by czbk on 16/8/15.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLHomeTitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置默认跟选中的图片
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        
        //设置标题颜色
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        //设置大小
        sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //交换文字跟图片的位置
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)! + 5
    }

}
