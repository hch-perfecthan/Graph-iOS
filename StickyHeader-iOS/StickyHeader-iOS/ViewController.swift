//
//  ViewController.swift
//  StickyHeader-iOS
//
//  Created by Chang-Hoon Han on 2020/07/29.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 방법2 - Bottom Sheet 컨트롤러 붙이기
        let controller = BottomSheetController(nibName: String(describing: BottomSheetController.self), bundle: nil);
        attachBottomSheet(controller: controller, headerHeight: UIScreen.main.bounds.height / 2, contentHeight: self.view.frame.height, paddingBottom: 0);
        
        // 방법1 - Bottom Sheet 컨트롤러 붙이기
        //let controller = BottomViewController(nibName: String(describing: BottomViewController.self), bundle: nil)
        //attachBottomSheet(controller: controller);
        
        /**
         * TODO PERFECTHAN SOPullUpView
         * https://github.com/Ahmadalsofi/SOPullUpView
         */
    }

    /**
     * OverlayContainerViewController 컨트롤러로 이동
     */
    @IBAction func goOverlayViewController(_ sender: UIButton) {
        let controller = OverlayViewController(nibName: String(describing: OverlayViewController.self), bundle: nil)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

    /**
     * CSStickyHeaderController 컨트롤러로 이동
     */
    @IBAction func goCSStickyHeaderController(_ sender: UIButton) {
        let controller = CSStickyHeaderController(nibName: String(describing: CSStickyHeaderController.self), bundle: nil)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

    /**
     * ParallaxHeaderController 컨트롤러로 이동
     */
    @IBAction func goParallaxHeaderController(_ sender: UIButton) {
        let controller = ParallaxHeaderController(nibName: String(describing: ParallaxHeaderController.self), bundle: nil)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
}
