//
//  ByvMenuTransition.swift
//  Pods
//
//  Created by Adrian Apodaca on 25/11/16.
//
//

import Foundation

public enum ByvTransationDirection {
    case toLeft
    case toRight
    case toTop
    case toBottom
}

open class ByvMenuTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    public var transitionDuration:TimeInterval = 0.3
    
    var preStatusBarStyle = UIApplication.shared.statusBarStyle
    public var newStatusBarStyle = UIApplication.shared.statusBarStyle
    
    public var presenting:Bool = true
    public var opened:Bool = false
    public var direction:ByvTransationDirection = .toRight
    
    public var onWideOpen: (() -> Void)? = nil
    public var startTransition: (() -> Void)? = nil
    public var closeTransition: (() -> Void)? = nil
    
    public override init() {
        super.init()
    }
    
    public func rotated() {
        // override Me!!!
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presenting {
            self.showMenu(transitionContext)
        } else {
            if (self.onWideOpen != nil) {
                self.openWide(transitionContext)
            } else {
                self.closeMenu(transitionContext)
            }
        }
    }
    
    public func showMenu(_ transitionContext: UIViewControllerContextTransitioning) {
        //override me!!!
        guard let menuVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        preStatusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.statusBarStyle = newStatusBarStyle
        
        transitionContext.containerView.addSubview(menuVc.view)
        
        if transitionContext.transitionWasCancelled {
            self.opened = false
            UIApplication.shared.statusBarStyle = self.preStatusBarStyle
            transitionContext.completeTransition(false)
        } else {
            self.opened = true
            transitionContext.completeTransition(true)
        }
    }
    
    public func openWide(_ transitionContext: UIViewControllerContextTransitioning) {
        //override me!!!
        closeMenu(transitionContext)
        
    }
    
    public func closeMenu(_ transitionContext: UIViewControllerContextTransitioning) {
        //override me!!!
        if transitionContext.transitionWasCancelled {
            self.opened = true
            transitionContext.completeTransition(false)
        } else {
            self.opened = false
            UIApplication.shared.statusBarStyle = self.preStatusBarStyle
            transitionContext.completeTransition(true)
        }
    }
    
    // MARK: - UIPercentDrivenInteractiveTransition
    
    public var interactionInProgress = false
    public var shouldCompleteTransition = false
    private var startPoint:CGPoint = CGPoint(x: 0.0, y: 0.0)

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionInProgress ? self : nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionInProgress ? self : nil
    }
    
    
    public func wireTo(viewController: UIViewController!) {
        prepareGestureRecognizerIn(view: viewController.view)
    }
    
    public func wireTo(view: UIView!) {
        prepareGestureRecognizerIn(view: view)
    }
    
    func prepareGestureRecognizerIn(view: UIView) {
        if !view.isKind(of: UIScrollView.self) {
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
            view.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / UIScreen.main.bounds.size.width)
        if direction == .toTop || direction == .toBottom {
            progress = (translation.y / UIScreen.main.bounds.size.height)
            if (direction == .toBottom && opened) || (direction == .toTop && !opened) {
                progress *= -1
            }
        } else if (direction == .toRight && opened) || (direction == .toLeft && !opened) {
            progress *= -1
        }
        
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        case .began:
            startPoint = translation
            interactionInProgress = true
            if !opened {
                if let action = self.startTransition {
                    action()
                }
            } else {
                if let action = self.closeTransition {
                    action()
                }
            }
            
        case .changed:
            if (
                (!opened &&
                ((direction == .toRight && translation.x < startPoint.x) ||
                (direction == .toLeft && translation.x > startPoint.x) ||
                (direction == .toTop && translation.y > startPoint.y) ||
                (direction == .toBottom && translation.y < startPoint.y)))
                    ||
                (opened &&
                    ((direction == .toRight && translation.x > startPoint.x) ||
                    (direction == .toLeft && translation.x < startPoint.x) ||
                    (direction == .toTop && translation.y < startPoint.y) ||
                    (direction == .toBottom && translation.y > startPoint.y)))
                ) {
                shouldCompleteTransition = false
                gestureRecognizer.isEnabled = false
            }
            shouldCompleteTransition = progress > 0.30
            update(progress)
            
        case .cancelled:
            gestureRecognizer.isEnabled = true
            interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("Unsupported")
        }
    }
    
    
}
