//
//  WSLEMoticonKeyBoardCell.swift
//  weibo-2
//
//  Created by czbk on 16/8/17.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//笑脸的自定义cell
class WSLEMoticonKeyBoardCell: UICollectionViewCell {
    //记录20个按钮
    private lazy var buttonArray: [WSLEmoticonButton] = [WSLEmoticonButton]()
    
    //删除按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        
        //添加点击事件
        button.addTarget(self, action: "clickDeleteButton", forControlEvents: .TouchUpInside)
        
        button.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
        button.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: .Normal)
        
        return button
    }()
    
    //重写frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //布局
    private func setupUI(){
        //添加表情按钮
        addChildButton()
        
        //添加删除按钮
        contentView.addSubview(deleteButton)
    }

    //添加表情按钮
    private func addChildButton() {
        //创建20个按钮
        for _ in 0..<20 {
            let button = WSLEmoticonButton()
            
            //添加点击事件
            button.addTarget(self, action: "clickEmoticonButton:", forControlEvents: .TouchUpInside)
            
            //设置字体大小,emoji
            button.titleLabel?.font = UIFont.systemFontOfSize(30)
            
            //添加按钮
            contentView.addSubview(button)
            
            //把按钮保存到数组中
            buttonArray.append(button)
        }
    }
    
    //布局子控件,设置frame
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemWidth = width / 7       //宽
        let itemHeight = height / 3     //高
        
        //
        for (i, value) in buttonArray.enumerate() {
            //x,y
            let x = i % 7
            let y = i / 7
            
            //
            value.size = CGSize(width: itemWidth, height: itemHeight)
            value.x = CGFloat(x) * itemWidth
            value.y = CGFloat(y) * itemHeight
        }
        
        deleteButton.size = CGSize(width: itemWidth, height: itemHeight)
        deleteButton.x = width - itemWidth
        deleteButton.y = height - itemHeight
    }
    
    //外部数据
    var emoticons: [WSLEmoticonModel]? {
        didSet {
            //数据是否有值
            guard let array = emoticons else {
                return
            }
            
            //默认情况下表情按钮都隐藏,当给按钮设置数据的时候显示出来
            for value in buttonArray {
                value.hidden = true
            }
            
            //设置数据
            for (i, value) in array.enumerate() {
                //取出表情按钮
                let button = buttonArray[i]
            
                //显示表情按钮
                button.hidden = false
                
                //给button赋值模型
                button.emoticon = value
                
                //判断图片的类型
                if value.type == "0" {
                    //图片                            //图片的路径
                    button.setImage(UIImage(named: value.path!), forState: .Normal)
                    
                    //只有是emoji才设置文字
                    button.setTitle(nil, forState: .Normal)
                } else {
                    //emoji
                    button.setTitle((value.code! as NSString).emoji(), forState: .Normal)
                    
                    //只有图片才设置图片
                    button.setImage(nil, forState: .Normal)
                }
            }
        }
    }
    
    
    //表情按钮的点击事件
    @objc private func clickEmoticonButton(sender: WSLEmoticonButton){
        //获取的表情模型
        let emoticonModel = sender.emoticon
        
        //发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(EmoticonNotificationName, object: emoticonModel)
    }
    
    //删除按钮的点击事件
    @objc private func clickDeleteButton(){
        //发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(DeleteEmoticonNotificationName, object: nil)
        
    }
}






















