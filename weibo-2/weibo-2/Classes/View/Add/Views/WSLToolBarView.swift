//
//  WSLToolBarView.swift
//  weibo-2
//
//  Created by czbk on 16/8/16.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//按钮的类型
enum WSLToolBarViewWithButtonType: Int {
    case Picture = 0
    case Mention = 1
    case Trend = 2
    case Emoticon = 3
    case Add = 4
}

//MARK: -UIStackView 是容器,不具备渲染功能,颜色根据子控件显示
class WSLToolBarView: UIStackView {
    //点击按钮执行的闭包
    var clickToolBarButton: ((type: WSLToolBarViewWithButtonType) -> ())?
    
    //表情按钮
    var emoticonButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加控件,约束
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //添加控件,约束
    private func setupUI(){
        
        //水平方向布局
        axis = .Horizontal
        
        //子控件的等比填充
        distribution = .FillEqually
        
        //添加按钮
        addChildButton("compose_toolbar_picture", type: .Picture)
        addChildButton("compose_mentionbutton_background", type: .Mention)
        addChildButton("compose_trendbutton_background", type: .Trend)
        emoticonButton = addChildButton("compose_emoticonbutton_background", type: .Emoticon)
        addChildButton("compose_add_background", type: .Add)
        
    }
    
    //创建子控件,并添加
    private func addChildButton(imageName: String, type: WSLToolBarViewWithButtonType) -> UIButton {
        //
        let button = UIButton()
        
        //根据枚举类型设置tag值
        button.tag = type.rawValue

        //添加点击事件
        button.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        
        //设置图片
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        
        //设置背景图片
        button.setBackgroundImage(UIImage(named: "compose_toolbar_background"), forState: .Normal)
        
        //取消高亮
        button.adjustsImageWhenHighlighted = false
        
        //添加
        addArrangedSubview(button)
        
        return button
    }
    
    //按钮的点击事件
    @objc private func clickButton(sender: UIButton) {
        //根据下标,获取枚举值
        let type = WSLToolBarViewWithButtonType(rawValue: sender.tag)!
        
        clickToolBarButton?(type: type)
    }
    
    //根据外面传入的键盘类型设置不同的icon
    func switchEmotionPicture(isEmoticon: Bool){
        //
        if isEmoticon {
            //选中的话,
            emoticonButton?.setImage(UIImage(named: "compose_keyboardbutton_background"), forState: .Normal)
            emoticonButton?.setImage(UIImage(named: "compose_keyboardbutton_background_highlighted"), forState: .Highlighted)
        } else {
            //没有选中的话显示笑脸
            emoticonButton?.setImage(UIImage(named: "compose_emoticonbutton_background"), forState: .Normal)
            emoticonButton?.setImage(UIImage(named: "compose_emoticonbutton_background_highlighted"), forState: .Highlighted)
        }
    }
}


