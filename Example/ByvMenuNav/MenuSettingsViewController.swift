//
//  MenuSettingsViewController.swift
//  ByvUtils
//
//  Created by Adrian Apodaca on 24/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ByvMenuNav

class MenuSettingsViewController: UIViewController {

    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var widthPercentageLbl: UILabel!
    @IBOutlet weak var scaleLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func timeChanged(_ slider: UISlider) {
        let value = floor(slider.value * 10) / 10
        timelbl.text = "\(value)"
        ByvMenuNav.instance?.leftMenu?.transition().transitionDuration = TimeInterval(value)
    }
    
    @IBAction func widthChanged(_ slider: UISlider) {
        let value = floor(slider.value * 100) / 100
        widthPercentageLbl.text = "\(value)"
        if let transition:LeftMenuTransition = ByvMenuNav.instance?.leftMenu?.transition() as? LeftMenuTransition {
            transition.menuWidthPecent = CGFloat(value)
        }
    }
    
    @IBAction func scaleChanged(_ slider: UISlider) {
        let value = floor(slider.value * 100) / 100
        scaleLbl.text = "\(value)"
        if let transition:LeftMenuTransition = ByvMenuNav.instance?.leftMenu?.transition() as? LeftMenuTransition {
            transition.menuScale = CGFloat(value)
        }
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
