//
//  WSLBottomView.swift
//  weibo-2
//
//  Created by czbk on 16/8/12.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLBottomView: UIView {
    //按钮
    var leftButton: UIButton?       //转发
    var centerButton: UIButton?     //评论
    var rightButton: UIButton?      //赞
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //布局
        setupUI()
    }
    //xib
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //
    private func setupUI(){
        //添加按钮
        leftButton = addChildButton("timeline_icon_retweet", title: "转发")
        centerButton = addChildButton("timeline_icon_comment", title: "评论")
        rightButton = addChildButton("timeline_icon_unlike",title: "赞")
        
        //添加按钮中间的竖线
        let oneLineView = addChildLineView()
        let twoLineView = addChildLineView()
        
        //约束
        leftButton?.snp_makeConstraints(closure: { (make) -> Void in
            make.leading.bottom.top.equalTo(self)
            make.width.equalTo(centerButton!)
        })
        centerButton?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.bottom.equalTo(self)
            make.leading.equalTo(leftButton!.snp_trailing)
            make.width.equalTo(rightButton!)
        })
        rightButton?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.bottom.trailing.equalTo(self)
            make.leading.equalTo(centerButton!.snp_trailing)
        })
        oneLineView.snp_makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(self)
            make.leading.equalTo(leftButton!.snp_trailing)
            make.trailing.equalTo(centerButton!.snp_leading)
        }
        twoLineView.snp_makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(self)
            make.leading.equalTo(centerButton!.snp_trailing)
            make.trailing.equalTo(rightButton!.snp_leading)
        }
    }
    
    //添加按钮的通用方法
    private func addChildButton(imageName: String, title: String) -> UIButton {
        let button = UIButton()
        
        //设置button
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: .Normal)
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        //添加子控件
        addSubview(button)
        
        return button
    }
    
    //添加竖线的通用方法
    private func addChildLineView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line"))
        addSubview(imageView)
        return imageView
    }

    var bottomViewModel: WSLStatusViewModel? {
        didSet{
            leftButton?.setTitle(bottomViewModel?.leftButtonCount, forState: .Normal)
            centerButton?.setTitle(bottomViewModel?.centerButtonCount, forState: .Normal)
            rightButton?.setTitle(bottomViewModel?.rightButtonCount, forState: .Normal)
        }
    }
}
