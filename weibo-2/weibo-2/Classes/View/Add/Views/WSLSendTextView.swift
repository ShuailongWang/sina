//
//  WSLSendTextView.swift
//  weibo-2
//
//  Created by czbk on 16/8/16.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//  自定义UITextView
//  @IBDesignable 实时看到修改后属性的值
@IBDesignable
class WSLSendTextView: UITextView {

   //占位label
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        
        //设置label
        label.font = UIFont.systemFontOfSize(12)
        label.text = "请输入内容~"
        label.textColor = UIColor.lightGrayColor()
        label.numberOfLines = 0
        
        return label
    }()
    
    //提供外界设置占位文字的属性,就是xib的时候,属性框中出现一个新属性
    @IBInspectable var placeHolder: String? {
        didSet {
            //把外面属性中文字赋值到上面占位label中
            placeHolderLabel.text = placeHolder
        }
    }
    
    //重写font
    override var font: UIFont? {
        didSet {
            if font != nil {
                //让占位文字跟外界的,设置同步
                placeHolderLabel.font = font
            }
        }
    }
    
    //重写text 
    override var text: String? {
        didSet {
            //根据文本是否有内容,而现实占位文字
            placeHolderLabel.hidden = hasText()
        }
    }
    
    //
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    
        //
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        //监听文字改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChange", name: UITextViewTextDidChangeNotification, object: nil)
        
        //添加占位label
        addSubview(placeHolderLabel)
        
        //约束
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: -10))
        
    }
    
    //MARK: - 监听文字改变的通知
    @objc private func textChange() {
        //根据文本框是否有值,来判断是否现实占位label
        placeHolderLabel.hidden = hasText()
    }
    
    //移除通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //设置占位labelde x,y坐标
        placeHolderLabel.frame.origin.x = 5
        placeHolderLabel.frame.origin.y = 7
    }
    
}














