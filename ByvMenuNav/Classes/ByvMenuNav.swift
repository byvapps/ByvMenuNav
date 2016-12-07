//
//  ByvMenuNav.swift
//  Pods
//
//  Created by Adrian Apodaca on 21/11/16.
//
//

import UIKit

public protocol ByvMenu : NSObjectProtocol {
    func transition() -> ByvMenuTransition
    func loadTransition()
    func barButton() -> UIBarButtonItem
}

open class ByvMenuNav: UINavigationController, UINavigationControllerDelegate {
    
    // MARK: - Vars
    
    static open var instance:ByvMenuNav? = nil
    
    private var _leftMenu: ByvMenu? = nil
    open var leftMenu: ByvMenu? {
        get {
            return _leftMenu
        }
        set {
            _leftMenu = newValue
            leftMenu?.loadTransition()
        }
    }
    
    private var _leftMenuIdentifier: String = "ByvLeftMenuVC"
    open var leftMenuIdentifier: String {
        get {
            return _leftMenuIdentifier
        }
        set {
            _leftMenuIdentifier = newValue
            if let menu:ByvMenu = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: _leftMenuIdentifier) as? ByvMenu {
                leftMenu = menu
            }
        }
    }
    
    public var allwaysShowLeftMenuButton = false
    
    // MARK: - UINavigationControllerDelegate protocol
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let leftMenu = leftMenu {
            if navigationController.viewControllers.index(of: viewController) == 0 || allwaysShowLeftMenuButton {
                addLeftMenuButtonTo(viewController)
            }
        }
    }
    
    // MARK: - UIViewController
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        ByvMenuNav.instance = self
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if leftMenu == nil {
            leftMenuIdentifier = _leftMenuIdentifier
        }
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let menu = self.leftMenu as? UIViewController {
            menu.viewWillTransition(to:size, with:coordinator)
        }
    }
    
    // MARK: - Static funcs
    
    public static func closeLeftMenu() {
        (ByvMenuNav.instance?.leftMenu as? UIViewController)?.dismiss(animated: true, completion: nil)
    }
    
    public static func showLeftMenu() {
        if let menu = ByvMenuNav.instance?.leftMenu {
            ByvMenuNav.instance?.showMenu(menu)
        }
    }
    
    open static func showModal(_ viewController: UIViewController, fromMenu: ByvMenu?) {
        ByvMenuNav.instance?.showModal(viewController, fromMenu:fromMenu)
    }
    
    open static func setRoot(viewController: UIViewController, fromMenu: ByvMenu?) {
        ByvMenuNav.instance?.setRoot([viewController], fromMenu:fromMenu)
    }
    
    open static func setRoot(viewControllers: Array<UIViewController>, fromMenu: ByvMenu?) {
        ByvMenuNav.instance?.setRoot(viewControllers, fromMenu:fromMenu)
    }
    
    // MARK: - Instance funcs
    
    func addLeftMenuButtonTo(_ viewController: UIViewController) {
        if let menu = leftMenu {
            let menuBtn = menu.barButton()
            menuBtn.target = self
            menuBtn.action = #selector(showLeftMenu)
            var buttons: Array<UIBarButtonItem> = [menuBtn]
            
            if let button = viewController.navigationItem.leftBarButtonItem, let target = button.target as? UIViewController, target != self {
                buttons.insert(button, at: 0)
            } else {
                if let items = viewController.navigationItem.leftBarButtonItems {
                    for button in items {
                        if let target = button.target as? UIViewController, target != self {
                            buttons.insert(button, at: 0)
                        }
                    }
                }
            }
            viewController.navigationItem.leftItemsSupplementBackButton = true
            viewController.navigationItem.leftBarButtonItems = buttons
        }
    }
    
    func showLeftMenu() {
        if let vc = leftMenu as? UIViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showMenu(_ menu:ByvMenu) {
        if let vc = menu as? UIViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func closeMenu(_ menu:ByvMenu) {
        (menu as? UIViewController)?.dismiss(animated: true, completion: nil)
    }
    
    open func showModal(_ viewController: UIViewController, fromMenu: ByvMenu?) {
        if let menu = fromMenu as? UIViewController {
            menu.dismiss(animated: true, completion: {
                self.present(viewController, animated: true, completion: nil)
            })
        } else {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    open func setRoot(_ viewControllers: Array<UIViewController>, fromMenu: ByvMenu?) {
        if self.viewControllers != viewControllers {
            if let menu = fromMenu, let transition:LeftMenuTransition = menu.transition() as? LeftMenuTransition {
                transition.onWideOpen = {
                    self.viewControllers = viewControllers
                    if fromMenu != nil && fromMenu as? UIViewController == self.leftMenu as? UIViewController {
                        self.addLeftMenuButtonTo(self.viewControllers[0])
                    }
                }
            } else {
                self.viewControllers = viewControllers
                if fromMenu != nil && fromMenu as? UIViewController == self.leftMenu as? UIViewController {
                    self.addLeftMenuButtonTo(self.viewControllers[0])
                }
            }
        }
        if let menu = fromMenu as? UIViewController {
            menu.dismiss(animated: true, completion: nil)
        }
    }
}
