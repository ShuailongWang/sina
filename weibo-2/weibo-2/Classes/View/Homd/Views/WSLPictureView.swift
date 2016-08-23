//
//  WSLPictureView.swift
//  weibo-2
//
//  Created by czbk on 16/8/13.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//标识
private let pictureViewCellID = "pictureViewCellID"

//item间距
private let itemMargin: CGFloat = 5

//列
private let colNum: CGFloat = 3

//item宽 = 屏幕的宽 - 间距 * (列 - 1) - 左右间距
private let itemWidth: CGFloat = (ScreenWidth - ((colNum - 1) * itemMargin) - 2 * homeViewMagin) / colNum

//item高
private let itemHeight: CGFloat = itemWidth + itemWidth * 0.3

//MARK: -设置UI界面
class WSLPictureView: UICollectionView {
    
    //控件
    //图片的个数
    private lazy var messageLabel: UILabel = UILabel(fontSize: 15, textColor: UIColor.blackColor())
    
    //数据数组
    var pictureArray: [WSLPictureModel]? {
        didSet {
            
            //图片的数量
            // messageLabel.text = "\(pictureArray!.count ?? 0)"
            
            //根据图片的个数,计算view的大小
            let size = calcSizeWithCount(pictureArray?.count ?? 0)
            
            //更新约束
            self.snp_updateConstraints { (make) -> Void in
                make.size.equalTo(size)
            }
            
            //刷新
            self.reloadData()
        }
    }

    //重写
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        //定义layout
        let flowLayout = UICollectionViewFlowLayout()
        
        //itemSize
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        //间距
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.minimumLineSpacing = itemMargin
        
        //
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        //布局
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //布局
    private func setupUI(){
        //注册cell
        registerClass(WSLPictureCell.self, forCellWithReuseIdentifier: pictureViewCellID)
        
        //设置代理
        dataSource = self
        delegate = self
        
        //添加控件
        addSubview(messageLabel)
        
        //约束
        messageLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
    }
    
    //计算防止图片View的大小
    private func calcSizeWithCount(count: Int) -> CGSize {
        //计算列   ,> 3就是3, 小于3的时候,就是本身1,2
        let cols = count > 3 ? 3 : count
        
        //行
        let rows = (count - 1) / 3 + 1
        
        //计算view的大小
        //宽 =  图片 * 个数 + 间距
        let currentWidth = itemWidth * CGFloat(cols) + CGFloat(cols - 1) * itemMargin
        //高
        let currentHeight = itemHeight * CGFloat(rows) + CGFloat(rows - 1) * itemMargin
        
        //
        return CGSize(width: currentWidth, height: currentHeight)
    }
    
    
}


//MARK: -数据源方法
extension WSLPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureArray?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //自定义cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pictureViewCellID, forIndexPath: indexPath) as! WSLPictureCell
        
        //model赋值 
        cell.prictureModel = pictureArray![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        //        photoBrowser.delegate = self;
        //        photoBrowser.currentImageIndex = indexPath.item;
        //        photoBrowser.imageCount = self.modelsArray.count;
        //        photoBrowser.sourceImagesContainerView = self.collectionView;
        //
        //        [photoBrowser show];
        
        let photoBrowser = SDPhotoBrowser()
        photoBrowser.delegate = self
        photoBrowser.currentImageIndex = indexPath.item
        photoBrowser.imageCount = (pictureArray?.count)!
        photoBrowser.sourceImagesContainerView = self
        
        photoBrowser.show()
    }
    
}

//
extension WSLPictureView: SDPhotoBrowserDelegate {
    //
    func photoBrowser(browser: SDPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
//        NSString *urlStr = [[self.modelsArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//        return [NSURL URLWithString:urlStr];
        
        let urlStr = pictureArray![index].thumbnail_pic?.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        
        return NSURL(string: urlStr!)
        
    }
    
    //高清图片
    func photoBrowser(browser: SDPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
// 不建议用此种方式获取小图，这里只是为了简单实现展示而已
//        SDCollectionViewDemoCell *cell = (SDCollectionViewDemoCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//
//        return cell.imageView.image;
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        
        let cell = self.cellForItemAtIndexPath(indexPath) as! WSLPictureCell
        
        return cell.imageView.image
    }
}


//MARK: -自定义cell
class WSLPictureCell: UICollectionViewCell {
    //懒加载控件
    
    //图片
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "timeline_image_placeholder"))
        /*
        case ScaleToFill
        case ScaleAspectFit  
        case ScaleAspectFill
        case Redraw 
        case Center
        case Top
        case Bottom
        case Left
        case Right
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
        */
        //修改图片的等比填充,保证图片比例不变
        imageView.contentMode = UIViewContentMode.ScaleToFill
        imageView.clipsToBounds = true      //多余的图片切掉
        
        return imageView
    }()
    //gif标识
    private lazy var gifImageView: UIImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
    
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
        //添加控件
        contentView.addSubview(imageView)
        contentView.addSubview(gifImageView)
        
        //约束
        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).offset(UIEdgeInsetsZero)
        }
        gifImageView.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(imageView)
            make.bottom.equalTo(imageView)
        }
    }
    
    //model
    var prictureModel: WSLPictureModel? {
        didSet {
            if let url = prictureModel?.thumbnail_pic {
                imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "timeline_image_placeholder"))
                
                
                //判断连接最后是否为gif
                gifImageView.hidden = !url.hasSuffix(".gif")
            }
        }
    }
}









