//
//  WSLMiddleView.swift
//  weibo-2
//
//  Created by czbk on 16/8/12.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit
import SnapKit

class WSLMiddleView: UIView {

    //懒加载控件
    private lazy var contentLabel: UILabel = {
        let label = UILabel(fontSize: 14, textColor: UIColor.grayColor())
        label.numberOfLines = 0
        return label
    }()
    
    //图片
    private lazy var pictureView: WSLPictureView = {
        let pictureView = WSLPictureView()
        pictureView.backgroundColor = self.backgroundColor
        return pictureView
    }()
    
    //标记约束
    var retweetViewBottomConstraint: Constraint?
    
    //重写
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //布局
    private func setupUI(){
        //背景颜色
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        //添加控件
        addSubview(contentLabel)
        addSubview(pictureView)
        
        //约束
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.top.leading.equalTo(self).offset(homeViewMagin)
            make.trailing.equalTo(self).offset(-homeViewMagin)
        }
        pictureView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp_bottom).offset(homeViewMagin)
            
        }
        
        //view的约束
        self.snp_makeConstraints { (make) -> Void in
            self.retweetViewBottomConstraint = make.bottom.equalTo(pictureView).offset(homeViewMagin).constraint
        }
        
    }
    
    
    //model赋值
    var minddleModel: WSLStatusViewModel? {
        didSet{
            //内容
//            contentLabel.text = minddleModel?.retweetContent
            contentLabel.attributedText = minddleModel?.retweetAttributedString
            
            //卸载上一次的约束
            retweetViewBottomConstraint?.uninstall()
            
            //判断是否有图片
            if let pictureArray = minddleModel?.statusModel?.retweeted_status?.pic_urls where pictureArray.count > 0 {
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
