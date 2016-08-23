//
//  WSLRefreshControl.swift
//  weibo-2
//
//  Created by czbk on 16/8/14.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//当前视图的高度
private let WSLRefreshControlHeight: CGFloat = 50

//刷新状态
enum WSLRefreshControlType: Int {
    case Normal = 0         //下拉刷新
    case Pulling = 1        //将要刷新
    case Refreshing = 2     //正在刷新
}


//自定义下拉刷新
class WSLRefreshControl: UIControl {
    //懒加载控件
    var currentScrollView: UIScrollView?
    
    private lazy var iconImageView: UIImageView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    
    //菊花
    private lazy var indicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

        activity.color = UIColor.blackColor()
        
        return activity
    }()
    
    //显示文字
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        
        //设置label
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.grayColor()
        label.text = "下拉刷新"
        
        return label
    }()
    
    //当前的状态
    var refreshState: WSLRefreshControlType = .Normal {
        didSet {
            //判断是哪个类型
            switch refreshState {
            
            //判断
            case .Normal:
                //显示文字为下拉刷新
                messageLabel.text = "下拉刷新"
                //菊花停止转动
                indicatorView.stopAnimating()
                //箭头显示,箭头重置
                iconImageView.hidden = false
                
                //动画
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    //复位
                    self.iconImageView.transform = CGAffineTransformIdentity
                })
                
                //刷新完成回到默认位置,前提上一次请求是正在刷新状态
                //oldValue 获取上一次的粗存的数据是正在刷新,然后我们在对contentInset.top减去一个自身的高度
                if oldValue == .Refreshing {
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        self.currentScrollView?.contentInset.top -= WSLRefreshControlHeight
                    })
                }
            case .Pulling:
                messageLabel.text = "松手就刷新"
                //  下拉箭头调转
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.iconImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                })
            case .Refreshing:
                //  显示文字为正在刷新
                messageLabel.text = "正在刷新"
                //  下拉箭头隐藏，开启风火轮
                iconImageView.hidden = true
                indicatorView.startAnimating()
                
                //  设置停留位置
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    //
                    self.currentScrollView?.contentInset.top += WSLRefreshControlHeight
                })
                
                //  发送通知
                sendActionsForControlEvents(.ValueChanged)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //添加控件,约束
    private func setupUI(){
        //添加控件
        addSubview(iconImageView)
        addSubview(indicatorView)
        addSubview(messageLabel)
        
        //使用系统约束
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: -35))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .Leading, relatedBy: .Equal, toItem: iconImageView, attribute: .Trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: iconImageView, attribute: .CenterY, multiplier: 1, constant: 0))
    }
    
    //监听tableView的滚动,拿到tableView,将控件将要添加到那个父视图上
    override func willMoveToSuperview(newSuperview: UIView?) {
        //判断父视图是否可以滚动的视图
        guard let scrollView = newSuperview as? UIScrollView else {
            return
        }
        
        //设置当前视图的frame
        self.frame.size.width = scrollView.frame.size.width
        self.frame.size.height = WSLRefreshControlHeight
        self.frame.origin.y = -WSLRefreshControlHeight
        
        //MARK: -1,kvo监听滚动对象contentOffset属性的改变
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        
        //全局赋值
        currentScrollView = scrollView
    }
    
    //MARK: -2,kvo方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //判断视图是否有值
        guard let scrollView = currentScrollView else {
            return
        }
        
        //print(scrollView.contentOffset.y)
        //偏移量
        let contentOffSetY = scrollView.contentOffset.y
        
        //计算临界点
        let maxY = -(scrollView.contentInset.top + WSLRefreshControlHeight)
        
        //判断是否在拖动
        if scrollView.dragging {
            //
            if contentOffSetY < maxY && refreshState == .Normal {
                //print("pulling")
                
                refreshState = .Pulling
            }else if contentOffSetY >= maxY && refreshState == .Pulling {
                refreshState = .Normal
            }
        }else{
            //
            if refreshState == .Pulling {
                refreshState = .Refreshing
            }
            //print("没有拖动")
        }
    }
    //结束刷新
    func endRefreshing() {
        //
        refreshState = .Normal
    }
    
    deinit {
        //MARK: -3,移除kvo
        currentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    
}
