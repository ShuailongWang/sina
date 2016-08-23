//
//  WSLWecomeController.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class WSLWecomeController: UIViewController {

    //背景图片
    private lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    //头像
    private lazy var headImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "avatar_default_big"))
        //圆角
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        
        //
        
        if let vaatar_large = WSLUserAccountViewModel.sharedUserAccount.userAccount?.avatar_large {
            imageView.sd_setImageWithURL(NSURL(string: vaatar_large), placeholderImage: UIImage(named: "avatar_default_big"))
        }
        
        return imageView
    }()
    
    //文字
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        
        //设置label
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        
        if let name = WSLUserAccountViewModel.sharedUserAccount.userAccount?.name {
            label.text = "欢迎回来,\(name)"
            
        }else{
            label.text = "欢饮回来"
        }
        
        return label
    }()
    
    override func loadView() {
        super.loadView()
        view = bgImageView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(WSLUserAccountViewModel.sharedUserAccount.userAccount?.name)")
    
        
        //布局
        setupUI()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //动画
        startAnimation()
    }
    
    //动画
    private func startAnimation(){
        //信息隐藏
        messageLabel.alpha = 0
        
        //跟新约束
        headImageView.snp_updateConstraints(closure: { (make) -> Void in
            make.top.equalTo(view).offset(100)
        })
        
        //动画
        UIView .animateWithDuration(3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                //重新布局
                self.view.layoutIfNeeded()
            }) { (_) -> Void in
                UIView .animateWithDuration(2, animations: { () -> Void in
                    //消息显示
                    self.messageLabel.alpha = 1
                    }, completion: { (_) -> Void in
                        
                        //发送通知
                        NSNotificationCenter.defaultCenter().postNotificationName(selectRootVCNotification, object: nil)
                })
        }
        
    }
    
    //布局
    private func setupUI(){
        //添加控件
        view.addSubview(headImageView)
        view.addSubview(messageLabel)
        
        //约束
        headImageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(200)
            make.size.equalTo(CGSize(width: 90, height: 90))
        }
        messageLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(headImageView.snp_bottom).offset(10)
        }
        
    }


}
