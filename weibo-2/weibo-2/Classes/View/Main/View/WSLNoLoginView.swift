//
//  WSLNoLoginView.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit
import SnapKit

class WSLNoLoginView: UIView {
    //闭包,注册或登录按钮点击时候
    var clickNologinButton: (()->())?
    
    //懒加载控件
    private lazy var cycleImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    private lazy var maskImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    private lazy var iconImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    //文字
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        
        //设置label
        label.text = "关注一些人，回这里看看有什么惊喜"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        label.numberOfLines = 0
        
        return label
    }()
    
    //注册按钮
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        
        //
        button.addTarget(self, action: "clickRegisterButton", forControlEvents: .TouchUpInside)
        button.setTitle("注册", forState: .Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Normal)
        
        return button
    }()
    
    //注册登录
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        
        //设置按钮
        button.addTarget(self, action: "clickLoginButton", forControlEvents: .TouchUpInside)
        button.setTitle("登录", forState: .Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Normal)
        
        return button
    }()

    //登录注册按钮点击的时候
    @objc private func clickRegisterButton(){
        print("注册")
        clickNologinButton?()
    }
    @objc private func clickLoginButton(){
        print("登录")
        clickNologinButton?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        //设置背景色
        backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1)
        
        //添加控件
        addSubview(cycleImageView)
        addSubview(maskImageView)
        addSubview(iconImageView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //约束
        cycleImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
        maskImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
        iconImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
        messageLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(maskImageView.snp_bottom)
            make.centerX.equalTo(maskImageView)
            make.width.equalTo(224)
        }
        registerButton.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(messageLabel)
            make.top.equalTo(messageLabel.snp_bottom).offset(10)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
        loginButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(messageLabel)
            make.top.height.width.equalTo(registerButton)
        }
    }
    
    
    //动画
    private func startAnimation(){
        //创建核心动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        //
        animation.toValue = 2 * M_PI
        
        //时长
        animation.duration = 20
        
        //重复次数
        animation.repeatCount = MAXFLOAT
        
        //
        animation.removedOnCompletion = false
        
        //添加动画
        cycleImageView.layer.addAnimation(animation, forKey: nil)
    }
    
    //页面不同,显示的内容不同
    func updateNologinView(msg: String?, imgName: String?){
        
        //
        if let msgLabel = msg, iconName = imgName {
            messageLabel.text = msgLabel
            iconImageView.image = UIImage(named: iconName)
            
            //旋转的图片隐藏
            cycleImageView.hidden = true
        }else{
            //旋转的图片显示
            cycleImageView.hidden = false
            
            //开启旋转
            startAnimation()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
