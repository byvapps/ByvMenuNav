//
//  MainViewController.swift
//  ByvMenuNav
//
//  Created by Adrian Apodaca on 9/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ByvMenuNav

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changed(_ sender: UISwitch) {
        ByvMenuNav.instance?.allwaysShowLeftMenuButton = sender.isOn
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
