//
//  QrErrorController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 02/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class QrErrorController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tryagain_listener(_ sender: UIButton) {
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
