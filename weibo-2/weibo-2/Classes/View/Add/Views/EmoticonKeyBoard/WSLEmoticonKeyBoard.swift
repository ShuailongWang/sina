//
//  WSLEmoticonKeyBoard.swift
//  weibo-2
//
//  Created by czbk on 16/8/17.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit



//  表情键盘自定义视图
/*
    1. 表情视图 -> UICollectionView
    2. toolBar视图 -> UIStackView
*/

//标识
private let EmotionCollectionViewCellID = "EmotionCollectionViewCellID"

class WSLEmoticonKeyBoard: UIView {
    //懒加载
    //工具条
    private lazy var toolBar: WSLEmoticonToolBar = {
        let toolBar = WSLEmoticonToolBar(frame: CGRectZero)
        
        return toolBar
    }()
    
    //表情图
    private lazy var emoticonCollectionView: UICollectionView = {
        //
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .Horizontal
        
        //创建view
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        
        //背景图片
        view.backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        
        //隐藏滚动条
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        //分页
        view.pagingEnabled = true
        
        //弹簧
        view.bounces = false
        
        //注册cell
        view.registerClass(WSLEMoticonKeyBoardCell.self, forCellWithReuseIdentifier: EmotionCollectionViewCellID)
        
        //代理
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    //页码
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        
        //
        page.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_selected")!)
        page.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_normal")!)
        
        return page
    }()
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //布局
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //添加控件,约束
    private func setupUI()  {
        //添加控件
        addSubview(emoticonCollectionView)
        addSubview(toolBar)
        addSubview(pageControl)
        
        //设置约束
        emoticonCollectionView.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(self)
        }
        toolBar.snp_makeConstraints { (make) -> Void in
            make.bottom.leading.trailing.equalTo(self)
            make.top.equalTo(emoticonCollectionView.snp_bottom)
        }
        pageControl.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(emoticonCollectionView)
            make.centerX.equalTo(emoticonCollectionView)
            make.height.equalTo(10)
        }
        
        //默认的页码
        let defaultIndexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        //设置页码
        setPageControlDataForIndexPath(defaultIndexPath)
        
        //toolBar的闭包
        toolBar.selectedButtonClosure = { [weak self] (type: WSLEmoticonToolBarType) in
            //  滚动到的indexPath
            let indexPath: NSIndexPath
            
            //判断点击了哪个按钮
            switch type {
            case .Normal:
                indexPath = NSIndexPath(forItem: 0, inSection: 0)
            case .Emoji:
                indexPath = NSIndexPath(forItem: 0, inSection: 1)
            case .LXH:
                indexPath = NSIndexPath(forItem: 0, inSection: 2)
            }
            //滚动到第几个表情
            self?.emoticonCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left
                , animated: false)
            
            //相应的页码
            self?.setPageControlDataForIndexPath(indexPath)
         }
    }
    
    //设置子控件的布局方式
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = emoticonCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //设置itemSize
        flowLayout.itemSize = emoticonCollectionView.size
        
        //设置间距
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }
    
    
    //通过indexPath绑定页数控件的数据
    private func setPageControlDataForIndexPath(indexPath: NSIndexPath) {
        //总共有多少页
        pageControl.numberOfPages = WSLEmoticonTools.sharedTools.allEmoticonArray[indexPath.section].count
        
        //当前页
        pageControl.currentPage = indexPath.item
    }
}

//MARK: - 数据源方法
extension WSLEmoticonKeyBoard: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //几按钮
        return WSLEmoticonTools.sharedTools.allEmoticonArray.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //几按钮几页
        return WSLEmoticonTools.sharedTools.allEmoticonArray[section].count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmotionCollectionViewCellID, forIndexPath: indexPath) as! WSLEMoticonKeyBoardCell

        cell.emoticons = WSLEmoticonTools.sharedTools.allEmoticonArray[indexPath.section][indexPath.item]
        
        return cell
    }
    
    //屏幕滚动的时候
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //偏移量
        let offsetX = scrollView.contentOffset.x
        
        //获取当前屏幕显示的cell,并对其进行x坐标排序
        let cells = emoticonCollectionView.visibleCells().sort { (oneCell, twoCell) -> Bool in
            return oneCell.x < twoCell.x
        }
        
        //判断哪个cell显示的多(宽显示的多)
        if cells.count == 2 {
            //获取单个cell
            let oneCell = cells.first!
            let twoCell = cells.last!
            
            //计算每个cell的偏差值
            let oneOffSetX = abs(oneCell.x - offsetX)
            let twoOffSetX = twoCell.x - offsetX
            
            //比较两个cell的偏差值
            let cell: UICollectionViewCell
            if oneOffSetX < twoOffSetX {
                cell = oneCell
            }else{
                cell = twoCell
            }
            
            //根据cell获取对应的indexPath
            let indexPath = emoticonCollectionView.indexPathForCell(cell)
            
            //获取组号
            let section = indexPath?.section
            
            //执行toolBar中的方法,选中哪个按钮
            toolBar.selectButton(section!)
            
            //相应的页码
            self.setPageControlDataForIndexPath(indexPath!)
        }
    }
}

















