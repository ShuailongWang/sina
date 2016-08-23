//
//  WSLHomeController.swift
//  weibo-2
//
//  Created by czbk on 16/8/11.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

private let homeTableViewCellID = "homeTableViewCellID"

//MARK: -controller
class WSLHomeController: WSLBaseController {
    //创建模态动画对象
    private lazy var presentedAnimation: WSLPresentedAnimation = WSLPresentedAnimation()
    
    //titleButton
    private lazy var titleButton: WSLHomeTitleButton = WSLHomeTitleButton()
    
    //创建statusListViewModel对象
    private lazy var statusListViewModel: WSLStatusListViewModel = WSLStatusListViewModel()
    
    //菊花转
    private lazy var pullUpView: UIActivityIndicatorView = {
        //创建控件
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        view.color = UIColor.grayColor()
        return view
    }()
    
    //下拉刷新
    private lazy var refreshView: UIRefreshControl = {
        let refresh = UIRefreshControl()
        
        //添加点击事件
        refresh.addTarget(self, action: "pullDownData", forControlEvents: .ValueChanged)
        
        return refresh
    }()
    
    //自定义下拉刷新控件
    private lazy var myRefreshView: WSLRefreshControl = {
        let refresh = WSLRefreshControl()
        
        //
        refresh.addTarget(self, action: "pullDownData", forControlEvents: .ValueChanged)
        
        return refresh
    }()
    
    //tip动画,提示
    private lazy var tipLabel: UILabel = {
        let label = UILabel(fontSize: 14, textColor: UIColor.whiteColor())
        
        //设置label
        label.backgroundColor = UIColor.orangeColor()   //背景颜色
        label.textAlignment = .Center                   //对齐
        label.text = "没有价值到数据"                     //文字
        label.hidden = true                             //默认隐藏
        
        return label
    }()
    
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //判断是否登录
        if isLogin {
            //设置导航栏的内容
            setupNavigationBar()
            
            //tableView相关
            setupTableView()
            
            //登录成功
            loadData()
            
        }else{
            //没有登录成功的话,设置图片,和提示信息
            noLoginView?.updateNologinView(nil, imgName: nil)
        }
        
    }
    
    //下拉刷新事件
    @objc private func pullDownData(){
        //加载数据
        loadData()
    }
    
    //表格相关
    private func setupTableView(){
        //tableView的行高  
        tableView.rowHeight = UITableViewAutomaticDimension //自动计算行高
        tableView.estimatedRowHeight = 200                  //预估行高
        tableView.separatorStyle = .None                    //黑线去掉
        
        //注册
        tableView.registerClass(WSLHomeStatusCell.self, forCellReuseIdentifier: homeTableViewCellID)
        
        //把菊花添加到脚视图
        tableView.tableFooterView = pullUpView
        
        //系统
        //1,把refre添加到tableView上面
        //tableView.addSubview(refreshView)
        //2,或者
        //self.refreshControl = refreshView
        
        //添加自定义下拉控件
        tableView.addSubview(myRefreshView)
    }
    
    //加载数据
    private func loadData(){
        //对象调用方法
        statusListViewModel.loadData(pullUpView.isAnimating()) { (isSuccess, message) -> () in
            //tip动画,判断菊花是否旋转,没有的话,显示tip
            if !self.pullUpView.isAnimating() {
                self.startTipAnimation(message)
            }
            
            //结束菊花转
            self.endRefreshing()
            
            //判断
            if isSuccess {
                //数据请求成功,刷新数据
                self.tableView.reloadData()
            }else{
                print("数据请求异常")
            }
        }
    }
    
    //tip动画
    private func startTipAnimation(message: String) {
        //如果tip动画正在执行,那么返回
        if tipLabel.hidden == false {
            return
        }
        
        //设置文字
        tipLabel.text = message
        
        //显示tipLabel
        tipLabel.hidden = false
        
        //动画
        UIView.animateWithDuration(1, animations: { () -> Void in
                //向下移动本身的高度
                self.tipLabel.transform = CGAffineTransformMakeTranslation(0, self.tipLabel.height)
            }) { (_) -> Void in
                //动画返回,隐藏
                UIView.animateWithDuration(1, animations: { () -> Void in
                        //复位
                        self.tipLabel.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        self.tipLabel.hidden = true
                })
        }
    }
    
    //结束菊花转
    private func endRefreshing(){
        //停止菊花转
        pullUpView.stopAnimating()
        
        //refre停止
        refreshView.endRefreshing()
        
        //自定义refre停止
        myRefreshView.endRefreshing()
    }
}


//MARK: -数据源方法
extension WSLHomeController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListViewModel.statusList.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(homeTableViewCellID, forIndexPath: indexPath) as! WSLHomeStatusCell
        
        //赋值
        cell.statusViewModel = statusListViewModel.statusList[indexPath.row]
        cell.selectionStyle = .None
        return cell
    }
    
    //显示cell的时候
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //判断到最后一个cell的时候
        if indexPath.row == statusListViewModel.statusList.count - 1{
            print("最后一条")
            
            //开启菊花转
            pullUpView.startAnimating()

            //加载数据
            loadData()
        }
    }
}

//MARK: -设置导航栏的内容
extension WSLHomeController {
    private func setupNavigationBar(){
        //1.设置左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, imageName: "navigationbar_friendattention", target: self, action: "clickNavLeftButton")
        
        //2.设置右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, imageName: "navigationbar_pop", target: self, action: "clickNavRightButton")
        
        //3.设置titleView
        let name = WSLUserAccountViewModel.sharedUserAccount.userAccount?.name
        titleButton.setTitle(name, forState: .Normal)
        
        //添加点击事件
        titleButton.addTarget(self, action: "clickNavTitleButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        //赋值
        navigationItem.titleView = titleButton
        
        //4,tip动画
        if let nav = self.navigationController {
            //设置frame
            tipLabel.frame = CGRect(x: 0, y: CGRectGetMaxY(nav.navigationBar.frame) - 30, width: nav.navigationBar.width, height: 30)
            //添加
            nav.view.insertSubview(tipLabel, belowSubview: nav.navigationBar)
        }
    }
}

//MARK: -按钮点击事件
extension WSLHomeController {
    //左
    @objc private func clickNavLeftButton(){
        print("left")
    }
    
    //右
    @objc private func clickNavRightButton(){
        print("right")
    }
    
    //中间的titleButton
    @objc private func clickNavTitleButton(){
        //1,当点击的时候,图片变一下
        titleButton.selected = !titleButton.selected
        
        //2,模态一个控制器,自定义
        let popoverVC = WSLHomeTitleController()
        
        //3,设置控制器model的样式,如果不设置的话,当前只有它自己的控制器
        popoverVC.modalPresentationStyle = .Custom
        
        //4,设置转场的代理,并设置frame
        presentedAnimation.presentFrame = CGRect(x: 100, y: 60, width: 180, height: 250)
        popoverVC.transitioningDelegate = presentedAnimation
        
        //5,弹出控制器
        presentViewController(popoverVC, animated: true, completion: nil)
    }
}























