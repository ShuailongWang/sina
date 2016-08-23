//
//  WSLHomeStatusCell.swift
//  weibo-2
//
//  Created by czbk on 16/8/12.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit
import SnapKit

//标记约束


class WSLHomeStatusCell: UITableViewCell {
    //标记约束
    var toolBarTopConstraint: Constraint?
    
    //MARK: - 原创微博视图
    private lazy var topView: WSLTopView = {
        let topView = WSLTopView()
        return topView
    }()
    
    //MARK: - 转发微博
    private lazy var middleView: WSLMiddleView = WSLMiddleView()
    
    //MARK: - 工具条
    private lazy var tooBar: WSLBottomView = WSLBottomView()
    
    //处理微博数据的ViewModel,给三个view赋值用的
    var statusViewModel: WSLStatusViewModel? {
        didSet{
            //赋值
            topView.TopModel = statusViewModel
            tooBar.bottomViewModel = statusViewModel
            
            //卸载上一次的约束
            toolBarTopConstraint?.uninstall()
            
            //判断是否有转发微博
            if statusViewModel?.statusModel?.retweeted_status != nil {
                //有转发微博,显示view
                middleView.hidden = false
            
                //更新约束
                tooBar.snp_updateConstraints(closure: { (make) -> Void in
                    //让工具条等于转发微博的底部
                    self.toolBarTopConstraint = make.top.equalTo(middleView.snp_bottom).constraint
                })
                
                //model
                middleView.minddleModel = statusViewModel
                
            }else{
                //没有转发微博,隐藏view
                middleView.hidden = true
                
                //更新约束
                tooBar.snp_updateConstraints(closure: { (make) -> Void in
                    //让工具条等于原创微博的底部
                    self.toolBarTopConstraint = make.top.equalTo(topView.snp_bottom).constraint
                })
            }
        }
    }
    
    //重写cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //布局
        setupUI()
    }
    //xib
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupUI(){
        //添加子控件
        contentView.addSubview(topView)     //原创微博
        contentView.addSubview(tooBar)      //工具条
        contentView.addSubview(middleView)  //转发微博
        
        //约束
        topView.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(contentView)
        }
        
        middleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom)
            make.leading.trailing.equalTo(topView)
        }
        
        tooBar.snp_makeConstraints { (make) -> Void in
            self.toolBarTopConstraint = make.top.equalTo(middleView.snp_bottom).constraint
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(35)
        }
        
        //cell
        contentView.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.top.equalTo(self)
            make.bottom.equalTo(tooBar)
        }
    }
}
