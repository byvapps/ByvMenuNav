//
//  MenuPresent.swift
//  Pods
//
//  Created by Adrian Apodaca on 21/11/16.
//
//

import Foundation
import QuartzCore

open class LeftMenuTransition: ByvMenuTransition {
    
    public var menuWidthPecent:CGFloat = 0.10
    public var menuScale:CGFloat = 0.9
    public var menuXTranslation:CGFloat = 100
    
    private var outViewController:UIViewController? = nil
    private var outView:UIView? = nil
    
    override public func rotated() {
        super.rotated()
        if opened {
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (timer) in
                    var bounds = UIScreen.main.bounds
                    self.outViewController?.view.frame = bounds
                    let snap = self.outViewController?.view.snapshotView(afterScreenUpdates: true)!
                    var frame = bounds
                    frame.size.width *= self.menuScale
                    frame.size.height *= self.menuScale
                    frame.origin.y = (bounds.size.height - frame.size.height) / 2.0
                    frame.origin.x = bounds.size.width - (bounds.size.width * self.menuWidthPecent)
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.outView?.frame = frame
                    },completion: nil)
                    snap?.frame = (self.outView?.bounds)!
                    snap?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    self.outView?.addSubview(snap!)
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    public override func showMenu(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let _vc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let menuVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        preStatusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.statusBarStyle = newStatusBarStyle
        
        var menuStartFrame = UIScreen.main.bounds
        menuStartFrame.origin.x -= menuXTranslation
        menuVc.view.frame = menuStartFrame
        
        outViewController = _vc
        outView = outViewController?.view.snapshotView(afterScreenUpdates: true)
        outView?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        outView?.frame = UIScreen.main.bounds
        self.updateOutView()
        
        transitionContext.containerView.addSubview(menuVc.view)
        
        transitionContext.containerView.addSubview(outView!)
        
        UIView.animateKeyframes(
            withDuration: transitionDuration,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    var frame = UIScreen.main.bounds
                    frame.size.width *= self.menuScale
                    frame.size.height *= self.menuScale
                    frame.origin.y = (UIScreen.main.bounds.size.height - frame.size.height) / 2.0
                    frame.origin.x = UIScreen.main.bounds.size.width - (UIScreen.main.bounds.size.width * self.menuWidthPecent)
                    self.outView?.frame = frame
                    menuVc.view.frame = UIScreen.main.bounds
                })
        },
            completion: { _ in
                if transitionContext.transitionWasCancelled {
                    self.opened = false
                    UIApplication.shared.statusBarStyle = self.preStatusBarStyle
                    self.outView?.removeFromSuperview()
                    self.outView = nil
                    transitionContext.completeTransition(false)
                } else {
                    self.opened = true
                    self.wireTo(view: self.outView!)
                    transitionContext.completeTransition(true)
                }
        })
    }
    
    public override func openWide(_ transitionContext: UIViewControllerContextTransitioning) {
        
        UIView.animateKeyframes(
            withDuration: transitionDuration,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    var frame = self.outView?.frame
                    frame?.origin.x = UIScreen.main.bounds.size.width
                    self.outView?.frame = frame!
                })
        },
            completion: { _ in
                
                if let completion = self.onWideOpen {
                    completion()
                }
                self.onWideOpen = nil
                self.closeMenu(transitionContext)
        })
    }
    
    public override func closeMenu(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let newVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        
        outViewController = newVc
        let snap = newVc.view.snapshotView(afterScreenUpdates: true)!
        snap.frame = (outView?.bounds)!
        snap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        outView?.addSubview(snap)
        
        UIView.animateKeyframes(
            withDuration: transitionDuration,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    self.outView?.frame = UIScreen.main.bounds
                    newVc.view.frame = UIScreen.main.bounds
                })
        },
            completion: { _ in
                if transitionContext.transitionWasCancelled {
                    self.opened = true
                    transitionContext.completeTransition(false)
                } else {
                    self.opened = false
                    UIApplication.shared.statusBarStyle = self.preStatusBarStyle
                    self.outView?.removeFromSuperview()
                    self.outView = nil
                    transitionContext.completeTransition(true)
                }
        })
    }
    
    func tappedOut(_ sender: Any) {
        ByvMenuNav.closeLeftMenu()
    }
    
    func updateOutView() {
        outView?.backgroundColor = UIColor.clear
        let outTap = UITapGestureRecognizer(target: self, action: #selector(tappedOut))
        outView?.addGestureRecognizer(outTap)
        outView?.layer.shadowColor = UIColor.black.cgColor
        outView?.layer.shadowOpacity = 0.3
        outView?.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    // MARK: - UIPercentDrivenInteractiveTransition
    
    override func startTransition() {
        super.startTransition()
        ByvMenuNav.showLeftMenu()
    }
    
    override func closeTransition() {
        super.closeTransition()
        ByvMenuNav.closeLeftMenu()
    }
}
