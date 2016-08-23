//
//  WSLPresentedAnimation.swift
//  weibo-2
//
//  Created by czbk on 16/8/15.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class WSLPresentedAnimation: NSObject {
    //判断是弹出动画,还是收回动画
    var isPresented: Bool = false
    
    //设置属性,让外面赋值
    var presentFrame: CGRect = CGRectZero
}


//MARK: -模态的代理
extension WSLPresentedAnimation: UIViewControllerTransitioningDelegate {
    //改变弹出view的尺寸
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        //创建对象
        let preseyionVC = WSLPresentionController(presentedViewController: presented, presentingViewController: presenting)
        //设置frame
        preseyionVC.myFrame = presentFrame
        
        //
        return preseyionVC
    }
    
    //自定义弹出的动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //弹出动画
        isPresented = true
        
        //返回的是协议,让self遵循这个协议,实现协议的方法
        return self
    }
    
    //自定义消失的动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //消失动画
        isPresented = false
        
        //返回的是协议,让self遵循这个协议,实现协议的方法
        return self
    }
}

//MARK: - 弹出和消失动画的代理方法
extension WSLPresentedAnimation: UIViewControllerAnimatedTransitioning {
    /// 动画执行的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    //获取"转场的上下文": 可以通过转场上下文获取,弹出的view和消失的view
    //UITransitionContextFromViewKey    消失的View
    //UITransitionContextToViewKey      弹出的view
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //使用三目运算符,判断是弹出动画,还是消失动画
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
    
    
    //自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        //获取弹出的view
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        //将弹出的view添加到containerView中
        transitionContext.containerView()?.addSubview(presentedView!)
        
        //设置描点,要不然执行的时候,是从中间显示的
        presentedView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView?.layer.anchorPoint = CGPointMake(0.5, 0)
        
        /**
        执行动画
        - parameter animations: 时长,直接调用上面的动画执行的时间
        - parameter completion: 动画完成后,做什么
        */
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            //设置弹出View的transform
            presentedView?.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                //告诉转场上下文,已经完成动画
                transitionContext.completeTransition(true)
        }
    }
    
    //自定义消失动画
    private func animationForDismissView(transitionContext: UIViewControllerContextTransitioning){
        //获取消失的view
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        //执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            //设置消失view的transform
            dismissView?.transform = CGAffineTransformMakeScale(1.0, 0.0001)
            }) { (_) -> Void in
                //从父控件移除
                dismissView?.removeFromSuperview()
                
                //告诉转场上下文,已经完成动画
                transitionContext.completeTransition(true)
        }
    }
    
}
