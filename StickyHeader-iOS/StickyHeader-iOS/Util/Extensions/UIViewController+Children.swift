//
//  UIViewController+Children.swift
//  StickyHeader-iOS
//
//  Created by Chang-Hoon Han on 2020/08/25.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addChild(_ child: UIViewController, in containerView: UIView) {
        guard containerView.isDescendant(of: view) else { return }
        addChild(child)
        containerView.addSubview(child.view)
        child.view.constraintToSuperview()
        child.didMove(toParent: self)
    }

    func removeChild(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
