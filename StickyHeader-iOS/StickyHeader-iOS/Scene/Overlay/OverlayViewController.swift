//
//  OverlayViewController.swift
//  StickyHeader-iOS
//
//  Created by Chang-Hoon Han on 2020/08/25.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit
import OverlayContainer

class OverlayViewController: UIViewController {

    enum OverlayNotch: Int, CaseIterable {
        case minimum, medium, maximum
    }
    
    private let overlayController = OverlayContainerViewController()
    private var viewController1: ContentViewController!
    private let viewController2 = BackdropViewController()
    private var viewController3: BottomViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewController1 = ContentViewController(nibName: String(describing: ContentViewController.self), bundle: nil)
        viewController3 = BottomViewController(nibName: String(describing: BottomViewController.self), bundle: nil)
        
        overlayController.delegate = self
        overlayController.viewControllers = [
            viewController1,
            viewController2,
            viewController3
        ]
        addChild(overlayController, in: view)
        
        DispatchQueue.main.async {
            let showsOverlay = true
            let targetNotch: OverlayNotch = showsOverlay ? .medium : .minimum
            self.overlayController.moveOverlay(toNotchAt: targetNotch.rawValue, animated: true)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func notchHeight(for notch: OverlayNotch, availableSpace: CGFloat) -> CGFloat {
        switch notch {
        case .maximum:
            return availableSpace * 7 / 8
        case .medium:
            return availableSpace / 2
        case .minimum:
            return availableSpace * 1 / 4
        }
    }

}


// MARK: - OverlayContainerViewControllerDelegate

extension OverlayViewController: OverlayContainerViewControllerDelegate {
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        return OverlayNotch.allCases.count
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        heightForNotchAt index: Int,
                                        availableSpace: CGFloat) -> CGFloat {
        let notch = OverlayNotch.allCases[index]
        return notchHeight(for: notch, availableSpace: availableSpace)
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        scrollViewDrivingOverlay overlayViewController: UIViewController) -> UIScrollView? {
        return (overlayViewController as? BottomViewController)?.scrollable.scrollView
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        shouldStartDraggingOverlay overlayViewController: UIViewController,
                                        at point: CGPoint,
                                        in coordinateSpace: UICoordinateSpace) -> Bool {
        guard let header = (overlayViewController as? BottomViewController)?.drawer else {
            return false
        }
        return header.bounds.contains(coordinateSpace.convert(point, to: header))
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        willTranslateOverlay overlayViewController: UIViewController,
                                        transitionCoordinator: OverlayContainerTransitionCoordinator) {
        transitionCoordinator.animate(alongsideTransition: { [weak self] context in
            self?.viewController2.view.alpha = context.translationProgress()
        }, completion: nil)
    }
}
