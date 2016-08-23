//
//  WSLSendPictureView.swift
//  weibo-2
//
//  Created by czbk on 16/8/16.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

private let WSLSendPictureControllerCellID = "WSLSendPictureControllerCellID"

class WSLSendPictureView: UICollectionView {
    //点击加号的时候,调用的闭包
    var selectedAddImageViewClosure: (()->())?
    
    //图片数据数组
    lazy var images: [UIImage] = [UIImage]()
    
    //frame
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        //
        setupUI()
    }
    //xib
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置UI部分
    private func setupUI() {
        //注册cell
        registerClass(WSLSendPictureViewCell.self, forCellWithReuseIdentifier: WSLSendPictureControllerCellID)
        
        //数据源代理
        dataSource = self
        delegate = self
    }
    
    //布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //列
        let colNum: CGFloat = 3
        
        //间距
        let itemMargin: CGFloat = 5
        
        //宽
        let itemWidth = (self.frame.size.width - (colNum - 1) * itemMargin) / colNum
        
        //获取布局方式
        let flowLayout = self.collectionViewLayout as!  UICollectionViewFlowLayout
        
        //设置itemSize
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        //间距
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.minimumLineSpacing = itemMargin
    }
}


//MARK: - collection的代理方法
extension WSLSendPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    //
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //判断,如果是0 或者9 的时候,那么不需要添加 + 号
        if images.count == 0 || images.count == 9 {
            return images.count
        }else {
            //不是的话,加一个cell,来显示+
            return images.count + 1
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(WSLSendPictureControllerCellID, forIndexPath: indexPath) as! WSLSendPictureViewCell
        
        //如果item = 数组的总数,那么显示加号,不传值
        if indexPath.item == images.count {
            cell.image = nil
        }else {
            //数据赋值
            cell.image = images[indexPath.item]
            
            //删除按钮的闭包
            cell.deleteButtonClosure = { [weak self] in
                //删除指定图片
                self?.images.removeAtIndex(indexPath.item)
                
                //当没有数据的时候,隐藏
                if self?.images.count == 0 {
                    self?.hidden = true
                }
                
                //更新数据
                self?.reloadData()
            }
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == images.count {
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
            
            //执行闭包,去控制器中,执行点击加号的方法,因为调用相册的方法在哪里
            selectedAddImageViewClosure?()
        }
    }
}

//MARK: -自定义cell
class WSLSendPictureViewCell: UICollectionViewCell {
    //点击删除按钮的闭包
    var deleteButtonClosure: (() -> ())?
    
    //懒加载控件
    //图片
    private lazy var imageView: UIImageView = UIImageView()
    
    //删除按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        
        //添加点击事件
        button.addTarget(self, action: "clickDeleteButton", forControlEvents: .TouchUpInside)
        
        //设置button
        button.setImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        
        return button
    }()
    
    //重写
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //添加控件,设置约束
    private func setupUI() {
        //添加控件
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        //设置约束
        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).offset(UIEdgeInsetsZero)
        }
        deleteButton.snp_makeConstraints { (make) -> Void in
            make.top.trailing.equalTo(imageView)
        }
    }
    
    //数据赋值
    var image: UIImage? {
        didSet {
            //判断image为空的时候,赋值是+
            if image == nil {
                //加号图片
                imageView.image = UIImage(named: "compose_pic_add")
                
                //高亮图片
                imageView.highlightedImage = UIImage(named: "compose_pic_add_highlighted")
                
                //加号按钮上面不显示删除按钮
                deleteButton.hidden = true
            } else {
                //设置图片
                imageView.image = image
                
                //不要高亮
                imageView.highlightedImage = nil
                
                //显示删除按钮
                deleteButton.hidden = false
            }
        }
    }
}

//MARK: -删除按钮点击事件
extension WSLSendPictureViewCell {
    //删除事件
    @objc private func clickDeleteButton(){
        print("10")
        
        deleteButtonClosure?()
    }
}

//MARK: -添加图片的事件
extension WSLSendPictureView {
    //添加图片
    func addImage(image: UIImage) {
        //最多添加9张图片
        if images.count > 9 {
            return
        }
        
        //把图片添加到数组中
        images.append(image)
        
        //更新collectionView
        self.reloadData()
    }
}