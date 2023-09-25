//
//  ContentViewController.swift
//  StickyHeader-iOS
//
//  Created by Chang-Hoon Han on 2020/08/25.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!

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
