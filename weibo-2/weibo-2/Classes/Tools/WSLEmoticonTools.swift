//
//  WSLEmoticonTools.swift
//  weibo-2
//
//  Created by czbk on 16/8/18.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit


let NumberOfPage = 20   //每页显示20个表情

//处理表情
class WSLEmoticonTools: NSObject {
    //单例
    static let sharedTools: WSLEmoticonTools = WSLEmoticonTools()
    
    //构造函数私有化,外面使用WSLEmoticonTools()定义的时候,不可用
    private override init() {
        super.init()
        
        //
    }

    //创建boudle对象,这个对象是我们拖过来的bundle文件
    private lazy var emoticonBoudle: NSBundle = {
        //bundle路径
        let path = NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil)!
        
        //创建emoticonBundle对象
        let bundle = NSBundle(path: path)!
        
        //
        return bundle
    }()
    
    //默认图片数据
    private lazy var defaultEmoticonArray: [WSLEmoticonModel] = {
        return self.loadEmoticonsWithSubPath("default/info.plist")
    }()
    
    //默认emoji数据
    private lazy var emojiEmoticonArray: [WSLEmoticonModel] = {
        return self.loadEmoticonsWithSubPath("emoji/info.plist")
    }()
    
    //默认浪小花数据
    private lazy var LXHEmoticonArray: [WSLEmoticonModel] = {
        return self.loadEmoticonsWithSubPath("lxh/info.plist")
    }()
    
    //几按钮几页几表情
    lazy var allEmoticonArray: [[[WSLEmoticonModel]]] = {
        return [
            //默认表情的几页几表情
            self.sectionEmoticonsWithArray(self.defaultEmoticonArray),
            //emoji表情的几页几表情
            self.sectionEmoticonsWithArray(self.emojiEmoticonArray),
            //浪小花表情的几页几表情
            self.sectionEmoticonsWithArray(self.LXHEmoticonArray)
        ]
    }()
    
    //表情分成多少页显示,每页显示多少表情,每页的数据是数组,几页几表情
    private func sectionEmoticonsWithArray(emoticonArray: [WSLEmoticonModel]) -> [[WSLEmoticonModel]] {
        //根据表情的总数,没页显示20个表情,计算多少页
        let pageCount = (emoticonArray.count - 1) / NumberOfPage + 1
        
        //可变数组,每页是一个数组
        var arrayM = [[WSLEmoticonModel]]()
        
        //遍历页数,从数组中每20个表情截取,保存到数组中
        for page in 0..<pageCount {
            //开始位置
            let loc = page * NumberOfPage
            
            //长度
            var length = NumberOfPage
            
            //判断数组剩余的是否可以截取,不可截取的话会崩溃
            if loc + length > emoticonArray.count {
                //那么重新计算长度
                length = emoticonArray.count - loc
            }
            
            //截取范围
            let range = NSMakeRange(loc, length)
            
            //把截取的保存到数组中
            let subArray = (emoticonArray as NSArray).subarrayWithRange(range)
            
            //把截取的数组保存到可变数组中,转换类型
            arrayM.append(subArray as! [WSLEmoticonModel])
        }
        return arrayM
    }
    
    //根据表情子路经读取相应的数据
    private func loadEmoticonsWithSubPath(plistNameAndPath: String) -> [WSLEmoticonModel] {
        //获取plist文件路径
        let path = self.emoticonBoudle.pathForResource(plistNameAndPath, ofType: nil)!
        
        //读取文件
        let array = NSArray(contentsOfFile: path)
        
        //遍历数组,字典转模型
        var arrayM = [WSLEmoticonModel]()
        for dict in array! {
            //
            let model = WSLEmoticonModel(dict: dict as! [String : AnyObject])
            
            //判断model中图片类型,
            if model.type == "0" {
                //因为plist文件跟图片是同一个路径,所以,找到plist文件路径,换成图片路径
                let resulrt = (path as NSString).stringByDeletingLastPathComponent
                
                //拼接图片的路径
                model.path = resulrt + "/" + model.png!
            }
            
            //添加model
            arrayM.append(model)
        }
        
        return arrayM
    }
    
    
    //
    func searchEmoticonWithArray(chs: String) ->  WSLEmoticonModel? {
        //默认表情数组中里面查找
        for value in defaultEmoticonArray {
            //找到对应的表情模型
            if value.chs == chs {
                return value
            }
        }
        
        //浪小花
        for value in LXHEmoticonArray {
            //找到对应的表情模型
            if value.chs == chs {
                return value
            }
        }
        return nil
    }
}



















