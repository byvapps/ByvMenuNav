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
    
    @IBOutlet weak var direction: UISegmentedControl!
    @IBOutlet weak var presentSize: UISlider!
    @IBOutlet weak var presentSizeLbl: UILabel!
    @IBOutlet weak var presentScale: UISlider!
    @IBOutlet weak var presentScaleLbl: UILabel!
    @IBOutlet weak var menuScale: UISlider!
    @IBOutlet weak var menuScaleLbl: UILabel!
    @IBOutlet weak var menuTranslation: UISlider!
    @IBOutlet weak var menuTranslationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func presentSizeChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        presentSizeLbl.text = "\(value) %"
    }
    
    @IBAction func presentScaleChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        presentScaleLbl.text = "\(value) %"
    }
    
    @IBAction func menuScaleChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        menuScaleLbl.text = "\(value) %"
    }
    
    @IBAction func menuTranslationChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        menuTranslationLbl.text = "\(value) px"
    }
    
    @IBAction func update(_ sender: Any) {
        var dir:ByvTransationDirection = .toRight
        if direction.selectedSegmentIndex == 1 {
            dir = .toLeft
        } else if direction.selectedSegmentIndex == 2 {
            dir = .toTop
        } else if direction.selectedSegmentIndex == 3 {
            dir = .toBottom
        }
        
        ((ByvMenuNav.instance?.leftMenu?.transition()) as? BottomMenuTransition)?.setDirection(dir, presentSizePecent: CGFloat(presentSize.value / 100), presentScale: CGFloat(presentScale.value / 100), menuStartScale: CGFloat(menuScale.value / 100), menuStartTranslation: CGFloat(menuTranslation.value))
    }
    
    @IBAction func reset(_ sender: Any) {
        direction.selectedSegmentIndex = 0
        presentSize.value = 10
        presentSizeLbl.text = "10 %"
        presentScale.value = 90
        presentScaleLbl.text = "90 %"
        menuScale.value = 90
        menuScaleLbl.text = "90 %"
        menuTranslation.value = 100
        menuTranslationLbl.text = "100 px"
        update(self)
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
