//
//  ScrollableBottomSheetViewController
//  StickyHeader-iOS
//
//  Created by Chang-Hoon Han on 2020/07/30.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit

/**
 * Bottom Sheet 컨트롤러
 * https://github.com/AhmedElassuty/BottomSheetController
 * https://github.com/applidium/OverlayContainer
 * https://github.com/pujiaxin33/JXBottomSheetView
 * https://github.com/iosphere/ISHPullUp
 * https://github.com/material-components/material-components-ios/tree/develop/components/BottomSheet
 *
 * Bottom Sheet 설명
 * https://stackoverflow.com/questions/37967555/how-can-i-mimic-the-bottom-sheet-from-the-maps-app/38152508#38152508
 */
class ScrollableBottomSheetViewController: ScrollableStackViewController {
    
    @IBOutlet var backgroundView: UIButton?
    
    var fullMargineY: CGFloat = 100
    var partMargineY: CGFloat = UIScreen.main.bounds.height - 150
    var partMargineBottom: CGFloat = 150
    var hasShow = false

    private var callback: ((CGFloat, Bool) -> Void)? = { (_, _) -> () in }
    
    /**
     * Bottom Sheet 슬라이드 콜백
     */
    func callback(_ callback: ((CGFloat, Bool) -> ())?) -> Void {
        self.callback = callback
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        partMargineY = UIScreen.main.bounds.height - partMargineBottom
        
        DispatchQueue.main.async {
            
            self.prepareBackgroundView()
            
            if (self.partMargineBottom == 0) {
                self.show()
            } else {
                /**
                 * Bottom Sheet 초기 애니메이션 효과 처리
                 *
                UIView.animate(withDuration: 0.6, animations: { [weak self] in
                    let frame = self?.view.frame
                    let partMargineY = self?.partMargineY
                    let fullMargineY = self?.fullMargineY
                    self?.view.frame = CGRect(x: 0, y: partMargineY!, width: frame!.width, height: frame!.height - fullMargineY!)
                    self?.hasShow = true
                    self?.callback?(0.0, true)
                })*/
                let frame = self.view.frame
                let partMargineY = self.partMargineY
                let fullMargineY = self.fullMargineY
                self.view.frame = CGRect(x: 0, y: partMargineY, width: frame.width, height: frame.height - fullMargineY)
                self.hasShow = true
                self.callback?(0.0, false)
            }
        }
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ScrollableBottomSheetViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    /**
     * Bottom Sheet 백그라운드뷰 추가
     */
    func prepareBackgroundView(_ superView: UIView? = nil) {
        if let superView = superView {
            if (backgroundView == nil) {
                backgroundView = UIButton(frame: UIScreen.main.bounds)
                backgroundView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                backgroundView?.alpha = 0
                backgroundView?.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
            }
            if let backgroundView = backgroundView {
                superView.addSubview(backgroundView)
                superView.bringSubviewToFront(self.view)
            }
        } else {
            /*
            let blurEffect = UIBlurEffect.init(style: .dark)
            let bluredView = UIVisualEffectView.init(effect: blurEffect)
            bluredView.frame = UIScreen.main.bounds
            let visualEffect = UIVisualEffectView.init(effect: blurEffect)
            visualEffect.frame = UIScreen.main.bounds
            bluredView.contentView.addSubview(visualEffect)
            self.view.insertSubview(bluredView, at: 0)
            */
        }
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        
        if (y + translation.y >= fullMargineY) && (y + translation.y <= partMargineY) {
            if (y + translation.y >= fullMargineY) {
                let alpha = (fullMargineY / (y + translation.y))
                backgroundView?.alpha = alpha
                hasShow = false
                callback?(alpha, false)
            }
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            
            var duration =  velocity.y < 0 ? Double((y - fullMargineY) / -velocity.y) : Double((partMargineY - y) / velocity.y)
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    let alpha: CGFloat = 0.0
                    self.backgroundView?.alpha = alpha
                    self.hasShow = false
                    self.callback?(alpha, true)
                    self.view.frame = CGRect(x: 0, y: self.partMargineY, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    let alpha: CGFloat = 1.0
                    self.backgroundView?.alpha = alpha
                    self.hasShow = true
                    self.callback?(alpha, true)
                    self.view.frame = CGRect(x: 0, y: self.fullMargineY, width: self.view.frame.width, height: self.view.frame.height)
                }
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.scrollable.scrollView.isScrollEnabled = true
                }
            })
        }
    }
    
    /**
     * Bottom Sheet 열기 여부 체크
     */
    func isShow() -> Bool {
        if let backgroundView = self.backgroundView {
            if backgroundView.alpha == 1.0 {
                return true
            }
        } else {
            return self.hasShow
        }
        return false
    }
    
    /**
     * Bottom Sheet 열기
     */
    func show() {
        UIView.animate(withDuration: 0.3, animations: {
            let alpha: CGFloat = 1.0
            self.backgroundView?.alpha = alpha
            self.hasShow = true
            self.callback?(alpha, true)
            self.view.frame = CGRect(x: 0, y: self.fullMargineY, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    /**
     * Bottom Sheet 닫기
     */
    @objc func dismiss(_ animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            let alpha: CGFloat = 0.0
            self.backgroundView?.alpha = alpha
            self.hasShow = false
            self.callback?(alpha, animated)
            self.view.frame = CGRect(x: 0, y: self.partMargineY, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: UIGestureRecognizerDelegate

extension ScrollableBottomSheetViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        let y = view.frame.minY
        if (y == fullMargineY && scrollable.scrollView.contentOffset.y + scrollable.scrollView.contentInset.top <= 0 && direction > 0) || (y == partMargineY) {
            //print("\(scrollable.scrollView.contentOffset.y), \(scrollable.scrollView.contentInset.top)")
            scrollable.scrollView.isScrollEnabled = false
        } else {
            //print("\(scrollable.scrollView.contentOffset.y), \(scrollable.scrollView.contentInset.top)")
            scrollable.scrollView.isScrollEnabled = true
        }
        return false
    }
}
