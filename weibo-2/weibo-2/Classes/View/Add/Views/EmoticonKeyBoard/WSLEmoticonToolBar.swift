//
//  WSLEmoticonToolBar.swift
//  weibo-2
//
//  Created by czbk on 16/8/17.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit


//枚举,判断表情的类型
enum WSLEmoticonToolBarType: Int {
    case Normal = 100     //默认表情
    case Emoji = 101      //emoji表情
    case LXH = 102        //浪小花
}

class WSLEmoticonToolBar: UIStackView {
    //闭包
    var selectedButtonClosure: ((type: WSLEmoticonToolBarType)->())?
    
    //全局,记录按钮
    var oldButton: UIButton?
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加控件,设置布局
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //布局
    private func setupUI() {
        //设置UIStackView属性
        axis = .Horizontal          //水平布局
        distribution = .FillEqually //等比填充
        
        //添加子控件
        addChildButton("默认", imageName: "left", type: .Normal)
        addChildButton("Emoji", imageName: "mid", type: .Emoji)
        addChildButton("浪小花", imageName: "right", type: .LXH)
    
    }
    
    //添加自按钮的通用方法
    private func addChildButton(title: String, imageName: String, type: WSLEmoticonToolBarType) {
        //
        let button = UIButton()
        
        //tag值
        button.tag = type.rawValue
        //当时默认的时候,选择
        if type == .Normal {
            oldButton?.selected = false
            button.selected = true
            oldButton = button
        }
        
        //添加点击事件
        button.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        
        //设置button
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        //不同状态的文字颜色
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Selected)
        
        //背景图片
        button.setBackgroundImage(UIImage(named: "compose_emotion_table_\(imageName)_normal"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "compose_emotion_table_\(imageName)_selected"), forState: .Selected)
        
        //取消高亮
        button.adjustsImageWhenHighlighted = false
        
        //添加
        addArrangedSubview(button)
    }
    
    //按钮的点击事件
    @objc private func clickButton(sender: UIButton){
        //判断上次点击的按钮是否跟现在的一样,一样返回return
        if oldButton == sender {
            return
        }
        
        //上一次按钮取消选中
        oldButton?.selected = false
        
        //设置按钮选中状态
        sender.selected = true
        
        //赋值
        oldButton = sender
        
        //通过tag值,获取枚举值
        let type = WSLEmoticonToolBarType(rawValue: sender.tag)
        
        //调用闭包
        selectedButtonClosure?(type: type!)
    }
    
    //外面传过来的值
    func selectButton(section: Int){
        //通过tag值获取button
        let button = viewWithTag(section + 100) as! UIButton
        
        //判断当前是否是选中的按钮,是的话,返回,不用再次选中了
        if oldButton?.tag == section + 100 {
            return
        }
        
        oldButton?.selected = false
        button.selected = true
        oldButton = button
    }
}
