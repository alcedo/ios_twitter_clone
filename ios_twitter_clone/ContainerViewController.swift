//
//  ContainerViewController.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/30/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit

protocol ContainerViewDelegate {
    func toggleLeftPanel() -> Void
}

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class ContainerViewController: UIViewController, ContainerViewDelegate {
    var centerViewController: MainViewController!
    var centerNavigationController: UINavigationController!
    
    var leftViewController: SidePanelViewController?
    var currentState: SlideOutState = .BothCollapsed
    let centerPanelExpandedOffset: CGFloat = 130
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create View Controller and set it as a child
        self.centerViewController = MainViewController()
        self.centerViewController.delegate = self
        self.centerNavigationController = UINavigationController(rootViewController: self.centerViewController)

        self.view.addSubview(self.centerNavigationController.view)
        self.addChildViewController(self.centerNavigationController)
        self.centerNavigationController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        self.animateLeftPanel(notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = SidePanelViewController()
            leftViewController?.profileLinkCallBack = {() -> Void in
                self.loadProfileView()
            }
            leftViewController?.homeLinkCallBack = {() -> Void in
                self.centerViewController.reloadView!()
                self.toggleLeftPanel()
            }
            self.addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        self.view.insertSubview(sidePanelController.view, atIndex: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func loadProfileView() {
        let nvc = UINavigationController(rootViewController: ProfileViewController())
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
}
