//
//  CSStickyHeaderController.swift
//  StickyHeader-iOS
//
//  Created by Chang-Hoon Han on 2020/07/29.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit

class CSStickyHeaderController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items : [String] = ["CSStickyHeaderFlowLayout basic example", "Example to initialize in code", "Please Enjoy", "10", "9", "8", "7", "6", "5", "4", "3", "2", "1"]
    
    private var layout : CSStickyHeaderFlowLayout? {
        return collectionView.collectionViewLayout as? CSStickyHeaderFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPrefetchingEnabled = false
        collectionView.alwaysBounceVertical = true
        
        // 헤더 셋팅
        collectionView.register(UINib(nibName: "CollectionParallaxHeader", bundle: nil), forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "parallaxHeader")
        layout?.disableStretching = false
        layout?.parallaxHeaderAlwaysOnTop = true
        layout?.disableStickyHeaders = false
        layout?.parallaxHeaderReferenceSize = CGSize(width: self.view.frame.size.width, height: 200)
        layout?.parallaxHeaderMinimumReferenceSize = CGSize(width: self.view.frame.size.width, height: 80)
        
        // 섹션 헤더 셋팅
        collectionView.register(UINib(nibName: "CollectionViewSectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        layout?.headerReferenceSize = CGSize(width: view.frame.size.width, height: 50)
        
        // 셀 셋팅
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        layout?.itemSize = CGSize(width: view.frame.size.width, height: 60)
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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


// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension CSStickyHeaderController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "parallaxHeader", for: indexPath)
            return view
        } else if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath)
            view.backgroundColor = .lightGray
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.textLabel.text = items[indexPath.row]
        return cell
    }
    
}
