//
//  BaseViewController.swift
//  StickyHeader-iOS
//
//  Created by Chang-Hoon Han on 2020/07/29.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit
import OverlayContainer

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**
     * Bottom Sheet 붙이기
     */
    func attachBottomSheet(controller: ScrollableBottomSheetViewController, headerHeight: CGFloat = UIScreen.main.bounds.height / 2, contentHeight: CGFloat = UIScreen.main.bounds.height, paddingBottom: CGFloat = 0, backgroundTouchable: Bool = true) {
        
        if #available(iOS 11.0, *) {
            controller.fullMargineY = self.view.frame.size.height - contentHeight - (paddingBottom > 0 ? 0 : CGFloat(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            controller.partMargineBottom = headerHeight + paddingBottom + (paddingBottom > 0 ? CGFloat(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) : 0)
        } else {
            controller.fullMargineY = self.view.frame.size.height - contentHeight
            controller.partMargineBottom = headerHeight + paddingBottom
        }
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        
        let width  = self.view.frame.width
        let height = self.view.frame.height
        controller.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        
        if backgroundTouchable {
        } else {
            // Bottom Sheet 백그라운드 뷰 추가
            controller.prepareBackgroundView(self.view)
        }
    }
    
    enum OverlayNotch: Int, CaseIterable {
        case minimum, maximum
    }
    
    var overlayController: OverlayContainerViewController?
    private var backdropController: BackdropViewController?
    private var minimumHeight: CGFloat = 0
    private var maximumHeight: CGFloat = 0
    
    /**
     * Bottom Sheet 붙이기
     * https://github.com/applidium/OverlayContainer
     */
    func attachBottomSheet(controller: ScrollableStackViewController, minimumHeight: CGFloat = 0, maximumHeight: CGFloat = 0, isUserInteractionEnabled: Bool = false) {
        self.minimumHeight = minimumHeight
        self.maximumHeight = maximumHeight
        self.overlayController = OverlayContainerViewController()
        self.overlayController?.delegate = self
        self.backdropController = BackdropViewController()
        self.overlayController?.viewControllers = [
            backdropController!,
            controller
        ]
        addChild(self.overlayController!, in: view)
    }

    private func notchHeight(for notch: OverlayNotch, availableSpace: CGFloat) -> CGFloat {
        switch notch {
            case .maximum:
                return (maximumHeight <= 0 || maximumHeight > availableSpace) ? availableSpace * 7 / 8 : maximumHeight
            case .minimum:
                return (minimumHeight <= 0 || minimumHeight > availableSpace) ? availableSpace / 2 : minimumHeight
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

}

class BackdropViewController: UIViewController {
    
    var isUserInteractionEnabled: Bool = false
    
    override func loadView() {
        view = isUserInteractionEnabled ? PassThroughView() : UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
    }
}


// MARK: - OverlayContainerViewControllerDelegate

extension BaseViewController: OverlayContainerViewControllerDelegate {
    
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
        return (overlayViewController as? ScrollableStackViewController)?.scrollable.scrollView
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
            self?.backdropController?.view.alpha = context.translationProgress()
        }, completion: nil)
    }
}
