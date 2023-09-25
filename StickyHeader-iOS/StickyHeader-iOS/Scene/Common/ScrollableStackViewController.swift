//
//  ScrollableStackViewController.swift
//  StickyHeader-iOS
//
//  Created by Chang-Hoon Han on 2020/07/30.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit

class ScrollableStackViewController: BaseViewController {
    
    @IBOutlet var headerView: UIView?
    @IBOutlet var stickyView: UIView?
    @IBOutlet var scrollable: ScrollableStackView!
    @IBOutlet var scrollCell: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollable.stackView.distribution = .fillProportionally
        scrollable.stackView.alignment = .center
        scrollable.stackView.axis = .vertical;
        scrollable.scrollView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollable.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollable.scrollView.delaysContentTouches = false;
        scrollable.scrollView.canCancelContentTouches = true;
        scrollable.scrollView.showsVerticalScrollIndicator = false
        scrollable.scrollView.showsHorizontalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            scrollable.scrollView.contentInsetAdjustmentBehavior = .automatic
        } else {
            automaticallyAdjustsScrollViewInsets = true;
        };
        
        // 헤더뷰 셋팅
        let header = UIView.init(frame: .zero)
        if let headerView = headerView {
            header.frame = CGRect(x: 0, y: 0, width: scrollable.bounds.width, height: headerView.frame.height)
            header.backgroundColor = .black
            headerView.frame.origin.x = 0
            headerView.frame.origin.y = 0
            headerView.frame.size.width = header.frame.width
            header.addSubview(headerView)
        }
        
        // Sticky뷰 셋팅
        if let stickyView = stickyView {
            stickyView.frame.origin.x = 0
            stickyView.frame.origin.y = header.frame.height
            stickyView.frame.size.width = header.frame.width
            header.frame.size.height += stickyView.frame.height
            header.addSubview(stickyView)
        }
        
        // 헤더 관련 셋팅
        if header.frame.equalTo(.zero) {
        } else {
            scrollable.scrollView.parallaxHeader.view = header
            scrollable.scrollView.parallaxHeader.height = header.frame.height
            scrollable.scrollView.parallaxHeader.minimumHeight = 80;
            scrollable.scrollView.parallaxHeader.mode = .bottomFill
            scrollable.scrollView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
                // TODO 헤더 스크롤에 대한 타이틀 처리 등등
            }
        }
        
        // 뷰 추가
        DispatchQueue.main.async {
            if let scrollCell = self.scrollCell {
                self.scrollable.addArrangedSubview(scrollCell)
            }
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
