//
//  WSLSendWeiboViewController.swift
//  weibo-2
//
//  Created by czbk on 16/8/16.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit
import SVProgressHUD

//MARK: -添加控件,设置布局
class WSLSendWeiboViewController: UIViewController {
    //MARK: - 懒加载控件
    //左边按钮
    private lazy var rightSendButton: UIButton = {
        let button = UIButton()
        
        //添加点击事件
        button.addTarget(self, action: "clickSendButton", forControlEvents: .TouchUpInside)
        
        //设置button
        button.setTitle("发送", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        
        //设置不同状态的背景图片
        button.setBackgroundImage(UIImage(named: "common_button_orange"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), forState: .Highlighted)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Disabled)
        
        //设置大小
        button.size = CGSize(width: 45, height: 30)
        
        return button
    }()
    
    //titleView
    private lazy var titleLabelView: UILabel = {
        let label = UILabel(fontSize: 17, textColor: UIColor.blackColor())
        
        //文本内容
        //判断是否有,用户名
        if let name = WSLUserAccountViewModel.sharedUserAccount.userAccount?.name {
            let temp = "发微博\n\(name)"
            
            //获取名称的range
            let range = (temp as NSString).rangeOfString(name)
            
            //定义副文字
            let attribuedStr = NSMutableAttributedString(string: temp)
            
            //给副文字添加属性, 字体颜色,字号,
            attribuedStr.addAttributes([NSForegroundColorAttributeName:UIColor.darkGrayColor(), NSFontAttributeName: UIFont.systemFontOfSize(14)], range: range)

            //添加到label上面的副文字
            label.attributedText = attribuedStr
        } else {
            label.text = "发微博"
        }
        
        //设置label
        label.textAlignment = .Center               //对齐
        label.numberOfLines = 0                     //多行
        label.sizeToFit()                           //大小
        
        return label
    }()
    
    //写微博的文本框
    private lazy var textView: WSLSendTextView = {
        let view = WSLSendTextView()
        
        //设置代理
        view.delegate = self
        
        //
        view.placeHolder = "请输入内容~"
        view.font = UIFont.systemFontOfSize(16)
        //垂直方向,开启拖动
        view.alwaysBounceVertical = true
        
        return view
    }()
    
    //toolBar
    private lazy var toolBar: WSLToolBarView = {
        let toolBar = WSLToolBarView(frame: CGRectZero)
        
        return toolBar
    }()
    
    //配图
    private lazy var pictureView: WSLSendPictureView = {
        let picture = WSLSendPictureView()
        
        //设置颜色,
        picture.backgroundColor = self.textView.backgroundColor
        
        return picture
    }()
    
    //表情键盘
    private lazy var emoticonKeyBoard: WSLEmoticonKeyBoard = {
        let emoticonKeyBoard = WSLEmoticonKeyBoard()
        
        //设置键盘大小
        emoticonKeyBoard.size = CGSize(width: self.textView.width, height: 216)
        
        return emoticonKeyBoard
    }()
    
    
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加导航控件
        setNavupUI()
        
        //添加控件
        setupUI()
    }
    
    //添加导航条上的控件
    private func setNavupUI(){
        //左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", imageName: nil, target: self, action: "clickCancelButton")
        
        //右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSendButton)
        
        //titleView
        navigationItem.titleView = titleLabelView
    }

    private func setupUI(){
        //点击表情按钮的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clickEmoticonButton:", name: EmoticonNotificationName, object: nil)
        
        //删除表情按钮的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clickDeleteEmoticonButton", name: DeleteEmoticonNotificationName, object: nil)
        
        
        //发送按钮不可用
        navigationItem.rightBarButtonItem?.enabled = false
        
        //监听键盘改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        
        //设置背景颜色
        view.backgroundColor = UIColor.whiteColor()
        
        //添加控件
        view.addSubview(textView)
        view.addSubview(pictureView)
        view.addSubview(toolBar)
        
        //约束
        textView.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(toolBar.snp_top)
        }
        pictureView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textView).offset(150)
            make.centerX.equalTo(textView)
            make.width.height.equalTo(textView.snp_width).offset(-10)
        }
        toolBar.snp_makeConstraints { (make) -> Void in
            make.leading.bottom.trailing.equalTo(view)
            make.height.equalTo(35)
        }
        
        
        //toolBar的闭包
        toolBar.clickToolBarButton = { [weak self] (type: WSLToolBarViewWithButtonType) in
            switch type {
                //判断类型
            case .Picture:
                print("图片")
                //图片的点击事件
                self!.clickPictureButton()
            case .Mention:
                print("@")
            case .Trend:
                print("#")
            case .Emoticon:
                print("表情")
                
                //点击笑脸的事件
                self!.didSelecedEmoticon()
                
            case .Add:
                print("+")
            }
        }
        
        //pictureView的闭包
        pictureView.selectedAddImageViewClosure = { [weak self] in
            //调用相册的方法
            self!.clickPictureButton()
        }
    }

}

//MARK: -表情按钮的通知,删除表情按钮的通知事件
extension WSLSendWeiboViewController {
    //表情按钮
    @objc private func clickEmoticonButton(nsnoti: NSNotification){
        //获取表情模型
        let emoticon = nsnoti.object as! WSLEmoticonModel
        
        //表情,添加表情,代码封装
        textView.insertEmotion(emoticon)
    }
    
    //删除表情按钮
    @objc private func clickDeleteEmoticonButton(){
        //删除文本内容
        textView.deleteBackward()
    }
}

//MARK: -监听键盘的通知事件
extension WSLSendWeiboViewController {
    //
    @objc private func keyboardFrameChange(nsnoti: NSNotification) {
        //打印键盘的信息
        //print(nsnoti.userInfo)
        
        //获取键盘的frame
        let keyBoardFrame = (nsnoti.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).CGRectValue()
        
        //获取动画的时长,键盘出现的时间
        let duration = (nsnoti.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
        
        //更新约束
        toolBar.snp_updateConstraints { (make) -> Void in
            //工具条在键盘的上方         键盘的y - 屏幕的高 = 偏移量
            make.bottom.equalTo(view).offset(keyBoardFrame.origin.y - self.view.height)
        }
        
        //更新约束动画,偏移事件=键盘出现的时间
        UIView.animateWithDuration(duration) { () -> Void in
            //更新子控件
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: -实现textView的代理方法
extension WSLSendWeiboViewController: UITextViewDelegate {
    //内容改变
    func textViewDidChange(textView: UITextView) {
        //如果有内容的话,发送按钮可用,否则不可用
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    //拖动textVie的时候,键盘消失,UITextView继承uiscrollview
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //隐藏键盘
        self.view.endEditing(true)
    }
}

//MARK: -事件方法
extension WSLSendWeiboViewController {
    //左边按钮点击事件,取消
    @objc private func clickCancelButton(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //右边按钮点击事件,发送微博
    @objc private func clickSendButton(){
        //获取要发微博的内容
        let textStr = textView.emoticonText
        
        //获取accessToken
        let accessToken = WSLUserAccountViewModel.sharedUserAccount.accessToken!
        
        //显示菊花转
        SVProgressHUD.show()
        
        //判断发送的类型,图片+文字,文字
        if pictureView.images.count > 0 {
            //获取图片
            let image = pictureView.images.first!
            
            //请求
            WSLNewworkTools.sharedTools.sendPicture(accessToken, status: textStr, image: image, callBack: { (response, error) -> () in
                //判断
                if error != nil {
                    //
                    SVProgressHUD.showErrorWithStatus("网络异常,发送失败")
                    
                    print(error)
                    
                    return
                }
                
                SVProgressHUD.showSuccessWithStatus("发送成功")
            })
        }else {
            //请求数据
            WSLNewworkTools.sharedTools.send(accessToken, status: textStr) { (response, error) -> () in
                //判断error是否有值,有值,发送失败
                if error != nil {
                    //
                    SVProgressHUD.showErrorWithStatus("网络异常,发送失败")
                    
                    print(error)
                    
                    return
                }
                
                //成功
                SVProgressHUD.showSuccessWithStatus("发送成功")
                
            }
        }
        //发送完毕后,调到首页
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: - 按钮的点击事件,相机的代理
extension WSLSendWeiboViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //点击笑脸
    func didSelecedEmoticon(){
        //判断textView的inputView是否有值
        if textView.inputView == nil {
            //设置表情键盘
            textView.inputView = emoticonKeyBoard
            
            //笑脸的图片
            toolBar.switchEmotionPicture(true)
        } else {
            //设置为系统键盘
            textView.inputView = nil
            
            //笑脸的图片
            toolBar.switchEmotionPicture(false)
        }
        
        //设置第一响应者
        textView.becomeFirstResponder()
        
        //刷新inputView
        textView.reloadInputViews()
    }
    
    
    //处理点击图片逻辑
    func didSelectedPicture()
    {
        let picCtr = UIImagePickerController()
        picCtr.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            //设置来源类型
            picCtr.sourceType = .Camera
        }
        else
        {
            //设置图库
            picCtr.sourceType = .PhotoLibrary
        }
        
        //判断前置摄像头是否可用
        if UIImagePickerController.isCameraDeviceAvailable(.Front)
        {
            print("前摄像有不可用")
        }
        else if UIImagePickerController.isCameraDeviceAvailable(.Rear)
        {
            print("后摄像头可用")
        }
        else
        {
            print("没有摄像头")
        }
        
        //是否允许编辑
//        picCtr.allowsEditing = true
        presentViewController(picCtr, animated: true, completion: nil)
    }
    
    
    //点击图片,
    private func clickPictureButton(){
        //相册
        let picture = UIImagePickerController()
        
        //代理
        picture.delegate = self
        
        //判断,来源,相机,图库
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            //
            picture.sourceType = .Camera
        } else {
            //
            picture.sourceType = .PhotoLibrary
        }
        
        //判断前后摄像头是否可用
        if UIImagePickerController.isCameraDeviceAvailable(.Front) {
            print("前,可用")
        } else if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
            print("后,可用")
        } else {
            print("没有")
        }
        
        //是否可以编辑图片
//        picture.allowsEditing = true
        
        //弹出
        presentViewController(picture, animated: true, completion: nil)
    }
    
    //MARK: -UIImagePickerControllerDelegate 实现代理方法, 如果实现了代理方法直接调用dismis操作
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //等比压缩图片,把方法放到UIImage+Extension中
        let scaleImage = image.scaleImageWithScaleWith(100)
        
        //添加图片
        pictureView.addImage(scaleImage)
        
        //
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
 
}