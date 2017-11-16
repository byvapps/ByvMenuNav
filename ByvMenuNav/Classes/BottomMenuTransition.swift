//
//  BottomMenuTransition.swift
//  Pods
//
//  Created by Adrian Apodaca on 7/12/16.
//
//

import Foundation

open class BottomMenuTransition: ByvMenuTransition {
    
    public var backgroundColor:UIColor = UIColor.black
    public var menuStartFrame:CGRect = UIScreen.main.bounds
    public var menuEndFrame:CGRect = UIScreen.main.bounds
    public var menuWideFrame:CGRect = UIScreen.main.bounds
    public var presentStartFrame:CGRect = UIScreen.main.bounds
    public var presentEndFrame:CGRect = UIScreen.main.bounds
    public var presentWideFrame:CGRect = UIScreen.main.bounds
    
    
    private var outViewController:UIViewController? = nil
    private var outView:UIView? = nil
    private var menuV:UIView? = nil
    
    public init(direction: ByvTransationDirection,
                menuSizePercent:CGFloat = 0.9,
                presentScale:CGFloat = 0.9,
                menuStartScale:CGFloat = 1.0,
                menuStartTranslation:CGFloat = 0) {
        super.init()
        setDirection(direction, menuSizePercent: menuSizePercent, presentScale: presentScale, menuStartScale: menuStartScale, menuStartTranslation: menuStartTranslation)
    }
    
    public func setDirection(_ dir: ByvTransationDirection,
                                    menuSizePercent:CGFloat = 0.9,
                                    presentScale:CGFloat = 0.9,
                                    menuStartScale:CGFloat = 1.0,
                                    menuStartTranslation:CGFloat = 0) {
        self.menuEndFrame = UIScreen.main.bounds
        self.menuWideFrame = UIScreen.main.bounds
        self.presentStartFrame = UIScreen.main.bounds
        
        self.direction = dir
        
        // menuStartFrame
        var frame = UIScreen.main.bounds
        frame.size.width *= menuStartScale
        frame.size.height *= menuStartScale
        frame.origin.y = (UIScreen.main.bounds.size.height - frame.size.height) / 2.0
        frame.origin.x = (UIScreen.main.bounds.size.width - frame.size.width) / 2.0
        
        if dir == .toRight {
            frame.origin.x -= menuStartTranslation
        } else if dir == .toLeft {
            frame.origin.x += menuStartTranslation
        } else if dir == .toBottom {
            frame.origin.y -= menuStartTranslation
        } else if dir == .toTop {
            frame.origin.y += menuStartTranslation
        }
        
        self.menuStartFrame = frame
        
        //presentEndFrame
        frame = UIScreen.main.bounds
        frame.size.width *= presentScale
        frame.size.height *= presentScale
        frame.origin.y = (UIScreen.main.bounds.size.height - frame.size.height) / 2.0
        frame.origin.x = (UIScreen.main.bounds.size.width - frame.size.width) / 2.0
        
        let size:CGFloat = (UIScreen.main.bounds.size.width * (1.0 - menuSizePercent))
        
        if dir == .toRight {
            frame.origin.x = UIScreen.main.bounds.size.width - size
        } else if dir == .toLeft {
            frame.origin.x = -(frame.size.width - size)
        } else if dir == .toBottom {
            frame.origin.y = UIScreen.main.bounds.size.height - size
        } else if dir == .toTop {
            frame.origin.y = -(frame.size.height - size)
        }
        
        self.presentEndFrame = frame
        
        // presentWideFrame
        frame = self.presentEndFrame
        
        if dir == .toRight {
            frame.origin.x = UIScreen.main.bounds.size.width
        } else if dir == .toLeft {
            frame.origin.x = -UIScreen.main.bounds.size.width
        } else if dir == .toBottom {
            frame.origin.y = UIScreen.main.bounds.size.height
        } else if dir == .toTop {
            frame.origin.y = -UIScreen.main.bounds.size.height
        }
        
        self.presentWideFrame = frame
    }
    
    override public func rotated() {
        super.rotated()
        if opened {
            outViewController?.view.frame = UIScreen.main.bounds
            outViewController?.view.alpha = 1.0
            let snap = outViewController?.view.snapshotView(afterScreenUpdates: true)!
            self.outView?.frame = self.presentEndFrame
            snap?.frame = (outView?.bounds)!
            snap?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.outView?.addSubview(snap!)
            self.outView?.bringSubview(toFront: snap!)
            outViewController?.view.alpha = 0.0
        }
    }
    
    public override func showMenu(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let _vc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let _menuVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        preStatusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.statusBarStyle = newStatusBarStyle
        
        self.menuV = _menuVc.view
        self.menuV?.frame = menuStartFrame
        
        outViewController = _vc
        outView = outViewController?.view.snapshotView(afterScreenUpdates: true)
        outView?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        outView?.frame = presentStartFrame
        let outTap = UITapGestureRecognizer(target: self, action: #selector(tappedOut))
        outView?.addGestureRecognizer(outTap)
        outView?.layer.shadowColor = UIColor.black.cgColor
        outView?.layer.shadowOpacity = 0.3
        outView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        _vc.view.alpha = 0.0
        
        transitionContext.containerView.backgroundColor = self.backgroundColor
        transitionContext.containerView.addSubview(self.menuV!)
        transitionContext.containerView.addSubview(outView!)
        
        UIView.animateKeyframes(
            withDuration: transitionDuration,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    self.menuV?.frame = self.menuEndFrame
                    self.outView?.frame = self.presentEndFrame
                })
        },
            completion: { _ in
                if transitionContext.transitionWasCancelled {
                    self.opened = false
                    UIApplication.shared.statusBarStyle = self.preStatusBarStyle
                    self.outView?.removeFromSuperview()
                    self.outView = nil
                    _vc.view.alpha = 1.0
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
                    self.menuV?.frame = self.menuWideFrame
                    self.outView?.frame = self.presentWideFrame
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
        outViewController?.view.alpha = 1.0
        let snap = newVc.view.snapshotView(afterScreenUpdates: true)!
        snap.frame = (outView?.bounds)!
        snap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        outView?.addSubview(snap)
        outViewController?.view.alpha = 0.0
        UIView.animateKeyframes(
            withDuration: transitionDuration,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    self.menuV?.frame = self.menuStartFrame
                    self.outView?.frame = self.presentStartFrame
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
                    newVc.view.frame = UIScreen.main.bounds
                    newVc.view.alpha = 1.0
                    transitionContext.completeTransition(true)
                }
        })
    }
    
    @objc func tappedOut(_ sender: Any) {
        if let action = self.closeTransition {
            action()
        }
    }
}
