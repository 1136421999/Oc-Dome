//
//  MyNavigationController.swift
//  HQWG
//
//  Created by Hanwen on 2018/3/16.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit

private let NavScreenWidth = UIScreen.main.bounds.size.width
private let NavScreenHeight = UIScreen.main.bounds.size.height
// 默认的将要变透明的遮罩的初始透明度(全黑)
private let kDefaultAlpha: CGFloat = 0.6
// 当拖动的距离,占了屏幕的总宽高的3/4时, 就让imageview完全显示，遮盖完全消失
private let kTargetTranslateScale: CGFloat =  0.75
// 拖动距离
private let kMobileDistance: CGFloat = UIScreen.main.bounds.width/2
class MyNavigationController: UINavigationController {

    /// 截图的ImageView
    private lazy var screenshotImgView: UIImageView = {
        let screenshotImgView = UIImageView(frame: UIScreen.main.bounds)
        return screenshotImgView
    }()
    /// 截图上面的黑色半透明遮罩
    private lazy var coverView: UIView = {
        let coverView = UIView(frame: UIScreen.main.bounds)
        coverView.backgroundColor = UIColor.black
        return coverView
    }()
    private lazy var screenshotImgs = [UIImage]()
    private lazy var animationController: AnimationContoller = AnimationContoller()
    private lazy var panGestureRec : UIScreenEdgePanGestureRecognizer = {
        let panGestureRec = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.panGestureRec(panGestureRec:)))
        panGestureRec.edges = UIRectEdge.left
        return panGestureRec
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = CGSize(width: -0.8, height: 0)
        self.view.layer.shadowOpacity = 0.6;
        self.view.addGestureRecognizer(self.panGestureRec)
        self.interactivePopGestureRecognizer?.delegate = self
        setNavigationBar() // 统一设置导航栏
    }
    
    //MARK: 重写跳转
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        /// 重新定义push之后的Controller
        if self.viewControllers.count > 0 {
            screenShot()
            UIView.animate(withDuration: 0.5, animations: {
                viewController.hidesBottomBarWhenPushed = true
            })
        }
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        super.pushViewController(viewController, animated: animated)
    }
}
extension MyNavigationController {
    func setNavigationBar() {
//        hw_switchNavColor(UIColor.white)
    }
    
    func setStatusBarStyle() {
        //         第一步：在Info.plist中设置UIViewControllerBasedStatusBarAppearance 为NO
        //         第二步：在viewDidLoad中加一句
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent // 修改状态栏颜色
//         UIApplication.shared.statusBarStyle = UIStatusBarStyle.default // 修改状态栏颜色
        //        这样就可以把默认的黑色改为白色。
        //        第二种：只是部分控制器需要修改状态栏文字的颜色：
        //        可以重写以下方法即可！
        //        override func preferredStatusBarStyle() -> UIStatusBarStyle {
        //            return UIStatusBarStyle.LightContent;
        //        }
    }
}

// MARK: - 系统返回按钮监听扩展相关
/// 导航返回协议
@objc protocol NavigationProtocol {
    /// 导航将要返回方法
    /// - Returns: true: 返回上一界面， false: 禁止返回
    @objc optional func hw_navigationBackClick() -> Bool
}
extension UIViewController: NavigationProtocol {
    /// 导航将要返回方法
    /// - Returns: true: 返回上一界面， false: 禁止返回
    func hw_navigationBackClick() -> Bool {
        return true
    }
}
extension UINavigationController: UINavigationBarDelegate {
    /// 返回按钮点击监听
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count < (navigationBar.items?.count)! {
            return true
        }
        var shouldPop = false
        let vc: UIViewController = topViewController!
        if vc.responds(to: #selector(hw_navigationBackClick)) {
            shouldPop = vc.hw_navigationBackClick()
        }
        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            for subview in navigationBar.subviews {
                if 0.0 < subview.alpha && subview.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25) {
                        subview.alpha = 1.0
                    }
                }
            }
        }
        return false
    }
    // 手势返回监听
    @objc public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if childViewControllers.count == 1 {
            return false
        } else {
            return check_hw_navigationBackClick()
        }
    }
    /// 校验是否拦截了返回按钮事件
    fileprivate func check_hw_navigationBackClick() -> Bool {
        if topViewController?.responds(to: #selector(hw_navigationBackClick)) != nil {
            return topViewController?.hw_navigationBackClick() ?? true
        }
        return true
    }
}
// MARK: - 返回动画相关
extension MyNavigationController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animationController.navigationOperation = operation
        self.animationController.navigationController = self
        return self.animationController
    }
    @discardableResult
    override func popViewController(animated: Bool) -> UIViewController? {
        let index = self.viewControllers.count
        if self.screenshotImgs.count >= index - 1 {
            if self.screenshotImgs.count > 0 {
                self.screenshotImgs.removeLast()
            }
        }
        return super.popViewController(animated: animated)
    }
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        var removeCount = 0
        for vc in self.viewControllers.reversed() {
            if viewController == vc {
                break
            }
            screenshotImgs.removeLast()
            removeCount += 1
        }
        animationController.removeCount = removeCount
        return super.popToViewController(viewController, animated: animated)
    }
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        screenshotImgs.removeAll()
        animationController.removeAllScreenShot()
        return super.popToRootViewController(animated: animated)
    }
    
    @objc func panGestureRec(panGestureRec:UIScreenEdgePanGestureRecognizer) {
        if self.visibleViewController == self.viewControllers.first {
            return
        }
        switch panGestureRec.state {
        case .began: // 开始拖拽阶段
            dragBegin()
            break
        case .ended, .failed, .cancelled: // 结束拖拽阶段
            dragEnd()
            break
        default: // 正在拖拽阶段
            dragging(panGestureRec)
            break
        }
    }
    // MARK: - 开始拖动,添加图片和遮罩
    func dragBegin() {
        // 重点,每次开始Pan手势时,都要添加截图imageview 和 遮盖cover到window中
        self.view.window?.insertSubview(screenshotImgView, at: 0)
        self.view.window?.insertSubview(coverView, aboveSubview: screenshotImgView)
        // 并且,让imgView显示截图数组中的最后(最新)一张截图
        screenshotImgView.image = screenshotImgs.last
    }
    // MARK: - 结束拖动,判断结束时拖动的距离作相应的处理,并将图片和遮罩从父控件上移除
    func dragEnd() {
        // 取出挪动的距离
        let translateX = view.transform.tx
        // 取出宽度
        let width = view.frame.size.width
        if translateX <= kMobileDistance {
            // 如果手指移动的距离还不到屏幕的一半,往左边挪 (弹回)
            UIView.animate(withDuration: 0.3, animations: {
                // 重要~~让被右移的view弹回归位,只要清空transform即可办到
                self.view.transform = CGAffineTransform.identity
                // 让imageView大小恢复默认的translation
                self.screenshotImgView.transform = CGAffineTransform.init(translationX: -NavScreenWidth, y: 0)
                // 让遮盖的透明度恢复默认的alpha 1.0
                self.coverView.alpha = kDefaultAlpha;
            }) { (_) in
                self.screenshotImgView.removeFromSuperview()
                self.coverView.removeFromSuperview()
            }
        } else {
            // 如果手指移动的距离还超过了屏幕的一半,往右边挪
            UIView.animate(withDuration: 0.3, animations: {
                // 让被右移的view完全挪到屏幕的最右边,结束之后,还要记得清空view的transform
                self.view.transform = CGAffineTransform.init(translationX: width, y: 0)
                // 让imageView位移还原
                self.screenshotImgView.transform = CGAffineTransform.init(translationX: 0, y: 0)
                // 让遮盖alpha变为0,变得完全透明
                self.coverView.alpha = 0;
            }) { (_) in
                // 重要~~让被右移的view完全挪到屏幕的最右边,结束之后,还要记得清空view的transform,不然下次再次开始drag时会出问题,因为view的transform没有归零
                self.view.transform = CGAffineTransform.identity
                // 移除两个view,下次开始拖动时,再加回来
                self.screenshotImgView.removeFromSuperview()
                self.coverView.removeFromSuperview()
                // 执行正常的Pop操作:移除栈顶控制器,让真正的前一个控制器成为导航控制器的栈顶控制器
                self.popViewController(animated: false)
                // 重要~记得这时候,可以移除截图数组里面最后一张没用的截图了
                self.animationController.removeAllScreenShot()
            }
        }
    }
    // MARK: - 正在拖动,动画效果的精髓,进行位移和透明度变化
    func dragging(_ pan: UIPanGestureRecognizer) {
        if check_hw_navigationBackClick() == false { return }// 如果有拦截返回按钮操作
        // 得到手指拖动的位移
        let offsetX = pan.translation(in: self.view).x
        // 让整个view都平移     // 挪动整个导航view
        if offsetX > 0 {
            self.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0)
        }
        // 计算目前手指拖动位移占屏幕总的宽高的比例,当这个比例达到3/4时, 就让imageview完全显示，遮盖完全消失
        let currentTranslateScaleX: CGFloat = offsetX/self.view.frame.size.width
        if offsetX < NavScreenWidth {
            screenshotImgView.transform = CGAffineTransform .init(translationX: (offsetX - NavScreenWidth) * 0.6, y: 0)
        }
        // 让遮盖透明度改变,直到减为0,让遮罩完全透明,默认的比例-(当前平衡比例/目标平衡比例)*默认的比例
        let alpha: CGFloat = kDefaultAlpha - (currentTranslateScaleX/kTargetTranslateScale) * kDefaultAlpha
        coverView.alpha = alpha
    }
    func screenShot() {
        // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
        guard let beyondVC = view.window?.rootViewController else {
            return
        }
        // 要裁剪的矩形范围
        let rect = UIScreen.main.bounds
        // 背景图片 总的大小
        let size = rect.size
        // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
        //判读是导航栏是否有上层的Tabbar  决定截图的对象
        if self.tabBarController == beyondVC {
            beyondVC.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        } else {
            view.drawHierarchy(in: rect, afterScreenUpdates: false)
        }
        // 从上下文中,取出UIImage
        if  let snapshot = UIGraphicsGetImageFromCurrentImageContext() {
            screenshotImgs.append(snapshot)
        }
        // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
        UIGraphicsEndImageContext()
    }
}

// MARK: - 自定义动画
class AnimationContoller: NSObject {
    open var navigationController: UINavigationController?
    open var navigationOperation: UINavigationController.Operation?
    open var removeCount: Int = 0
    /// 所属的导航栏有没有TabBarController
    private var isTabbarExist = false
    private lazy var screenShotArray = [UIImage]()
    
    class func AnimationControllerWithOperation(_ operation: UINavigationController.Operation,_ navigationController: UINavigationController? = nil) -> AnimationContoller {
        let ac = AnimationContoller()
        ac.navigationController = navigationController
        ac.navigationOperation = operation
        return ac
    }
    
    func setNavigationController(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        let beyondVC = navigationController.view.window?.rootViewController ?? UIViewController()
        isTabbarExist = navigationController.tabBarController == beyondVC ? true : false
    }
    
    func removeLastScreenShot() {
        screenShotArray.removeLast()
    }
    
    func removeAllScreenShot() {
        screenShotArray.removeAll()
    }
}
extension AnimationContoller : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let screentImgView = UIImageView(frame: UIScreen.main.bounds)
        let screenImg = screenShot()
        screentImgView.image = screenImg
        //取出fromViewController,fromView和toViewController，toView
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) ?? UIViewController()
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) ?? UIViewController()
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) ?? UIView()
        var fromViewEndFrame = transitionContext.finalFrame(for: fromViewController)
        fromViewEndFrame.origin.x = UIScreen.main.bounds.size.width
        var fromViewStartFrame = fromViewEndFrame
        let toViewEndFrame = transitionContext.finalFrame(for: toViewController)
        let toViewStartFrame = toViewEndFrame
        let containerView = transitionContext.containerView
        if self.navigationOperation == UINavigationController.Operation.push {
            self.screenShotArray.append(screenImg)
            //这句非常重要，没有这句，就无法正常Push和Pop出对应的界面
            containerView.addSubview(toView)
            toView.frame = toViewStartFrame
            let nextVC = UIView(frame: CGRect.init(x: NavScreenWidth, y: 0, width: NavScreenWidth, height: NavScreenHeight))
            //将截图添加到导航栏的View所属的window上
            self.navigationController?.view.window?.insertSubview(screentImgView, at: 0)
            nextVC.layer.shadowColor = UIColor.black.cgColor
            nextVC.layer.shadowOffset = CGSize(width: -0.8, height: 0)
            nextVC.layer.shadowOpacity = 0.6
            self.navigationController?.view.transform = CGAffineTransform.init(translationX: NavScreenWidth, y: 0)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                self.navigationController?.view.transform = CGAffineTransform.init(translationX: 0, y: 0)
                screentImgView.center = CGPoint.init(x: -NavScreenWidth*0.5, y: NavScreenHeight*0.5)
            }) { (tag) in
                nextVC.removeFromSuperview()
                screentImgView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
        if self.navigationOperation == UINavigationController.Operation.pop {
            fromViewStartFrame.origin.x = 0
            containerView.addSubview(toView)
            let lastVcImgView = UIImageView(frame: CGRect(x: -NavScreenWidth, y: 0, width: NavScreenWidth, height: NavScreenHeight))
            //若removeCount大于0  则说明Pop了不止一个控制器
            if self.removeCount > 0 {
                for i in 0..<removeCount {
                    if i == removeCount - 1 {
                        //当删除到要跳转页面的截图时，不再删除，并将该截图作为ToVC的截图展示
                        lastVcImgView.image = self.screenShotArray.last
                        removeCount = 0
                        break
                    } else {
                        self.screenShotArray.removeLast()
                    }
                }
            } else {
                lastVcImgView.image = self.screenShotArray.last
            }
            screentImgView.layer.shadowColor = UIColor.black.cgColor
            screentImgView.layer.shadowOffset = CGSize(width: -0.8, height: 0)
            screentImgView.layer.shadowOpacity = 0.6
            self.navigationController?.view.window?.addSubview(lastVcImgView)
            self.navigationController?.view.addSubview(screentImgView)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                self.navigationController?.view.transform = CGAffineTransform.init(translationX: 0, y: 0)
                screentImgView.center = CGPoint.init(x: NavScreenWidth*1.5, y: NavScreenHeight*0.5)
                lastVcImgView.center = CGPoint.init(x: NavScreenWidth*0.5, y: NavScreenHeight*0.5)
            }) { (tag) in
                lastVcImgView.removeFromSuperview()
                screentImgView.removeFromSuperview()
                if self.screenShotArray.count > 0 {
                    self.screenShotArray.removeLast()
                }
                transitionContext.completeTransition(true)
            }
        }
        
    }
    
    
    
    func screenShot() -> UIImage {
        // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
        guard let beyondVC = self.navigationController?.view.window?.rootViewController else {
            return UIImage()
        }
        // 背景图片 总的大小
        let size = beyondVC.view.frame.size
        // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        // 要裁剪的矩形范围
        let rect = UIScreen.main.bounds
        //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
        //判读是导航栏是否有上层的Tabbar  决定截图的对象
        if isTabbarExist {
            beyondVC.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        } else {
            self.navigationController?.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        }
        // 从上下文中,取出UIImage
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
        UIGraphicsEndImageContext()
        return snapshot ?? UIImage()
    }
}
