//
//  WSLTopView.swift
//  weibo-2
//
//  Created by czbk on 16/8/12.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class WSLTopView: UIView {
    //懒加载控件
    private lazy var headImageView: UIImageView = {
        let iconImageView: UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
        iconImageView.layer.cornerRadius = 17
        iconImageView.layer.masksToBounds = true
        
        return iconImageView
    }()
    
    //认证类型
    private lazy var verifiedTypeImageView: UIImageView = UIImageView(image: UIImage(named: "avatar_vip"))
    
    //用户名
    private lazy var userNameLabel: UILabel = UILabel(fontSize: 15, textColor: UIColor.darkGrayColor())
    
    //会员等级
    private lazy var mbrankImageView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    //时间
    private lazy var timeLabel: UILabel = UILabel(fontSize: 12, textColor: UIColor.orangeColor())
    
    //来源
    private lazy var sourceLabel: UILabel = UILabel(fontSize: 12, textColor: UIColor.lightGrayColor())
    
    //微博内容
    private lazy var contentLabel: UILabel = {
        let label = UILabel(fontSize: 14, textColor: UIColor.darkGrayColor())
        label.numberOfLines = 0
        return label
    }()
    
    //标记约束
    var retweetViewBottomConstraint: Constraint?
    
    //图片
    private lazy var pictureView: WSLPictureView = {
        let pictureView = WSLPictureView()
        pictureView.backgroundColor = self.backgroundColor
        return pictureView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //布局
        setupUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //布局
    private func setupUI() {
        //添加控件
        addSubview(headImageView)
        addSubview(verifiedTypeImageView)
        addSubview(userNameLabel)
        addSubview(mbrankImageView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(contentLabel)
        addSubview(pictureView)
        
        
        //约束
        headImageView.snp_makeConstraints { (make) -> Void in
            make.top.leading.equalTo(self).offset(homeViewMagin)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        verifiedTypeImageView.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(headImageView).offset(5)
            make.bottom.equalTo(headImageView).offset(3)
        }
        
        userNameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(headImageView)
            make.leading.equalTo(headImageView.snp_trailing).offset(homeViewMagin)
        }
        
        mbrankImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userNameLabel)
            make.leading.equalTo(userNameLabel.snp_trailing).offset(homeViewMagin)
        }
        
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(headImageView)
            make.leading.equalTo(userNameLabel)
        }
        
        sourceLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(timeLabel)
            make.leading.equalTo(timeLabel.snp_trailing).offset(homeViewMagin)
        }
        
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(headImageView)
            make.trailing.equalTo(self).offset(-homeViewMagin)
            make.top.equalTo(headImageView.snp_bottom).offset(homeViewMagin)
            
        }
        pictureView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp_bottom)
        }
        
        //  关键约束  原创微博视图的底部约束 = 微博内容的底部约束 + 间距
        self.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(pictureView).offset(homeViewMagin).offset(homeViewMagin)
        }
    }
    
    //数据赋值
    var TopModel: WSLStatusViewModel? {
        didSet{
            //头像
            if let urlStr = TopModel?.statusModel?.user?.profile_image_url {
                headImageView.sd_setImageWithURL(NSURL(string: urlStr), placeholderImage: UIImage(named: "avatar_default_big"))
            }
            //时间
            timeLabel.text = TopModel?.time
            
            //会员等级
            mbrankImageView.image = TopModel?.mbrankImage
            
            //认证类型
            verifiedTypeImageView.image = TopModel?.verifiedTypeImage
            
            //用户名
            userNameLabel.text = TopModel?.statusModel?.user?.screen_name
            
            //微博内容
//            contentLabel.text = TopModel?.statusModel?.text
            contentLabel.attributedText = TopModel?.origianAttributedString
            
            //来源
            sourceLabel.text = TopModel?.sourceContent
            
            //卸载上一次的约束
            retweetViewBottomConstraint?.uninstall()
            
            //判断是否有图片
            if let pictureArray = TopModel?.statusModel?.pic_urls where pictureArray.count > 0 {
                //显示图片视图
                pictureView.hidden = false
                
                //图片model赋值
                pictureView.pictureArray = pictureArray
                
                //更新约束
                self.snp_updateConstraints(closure: { (make) -> Void in
                    self.retweetViewBottomConstraint = make.bottom.equalTo(pictureView).offset(homeViewMagin).constraint
                })
            }else {
                //隐藏图片视图
                pictureView.hidden = true
                
                //更新约束
                self.snp_updateConstraints(closure: { (make) -> Void in
                    self.retweetViewBottomConstraint = make.bottom.equalTo(contentLabel).offset(homeViewMagin).constraint
                })
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
