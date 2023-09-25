//
//  ParallaxHeaderController.swift
//  StickyHeader-iOS
//
//  Created by Chang-Hoon Han on 2020/07/29.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit

class ParallaxHeaderController: ScrollableStackViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
