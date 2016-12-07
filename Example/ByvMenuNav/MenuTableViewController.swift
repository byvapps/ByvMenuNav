//
//  MenuTableViewController.swift
//  ByvUtils
//
//  Created by Adrian Apodaca on 21/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ByvMenuNav

class MenuTableViewController: UITableViewController, ByvMenu {
    
    let _transition:ByvMenuTransition = LeftMenuTransition()
    let _statusBarStyle:UIStatusBarStyle = UIStatusBarStyle.lightContent
    let _barButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuButton") , style: .plain, target: nil, action: nil)

    // MARK: - ByvMenu protocol
    
    func transition() -> ByvMenuTransition {
        return _transition
    }
    
    func loadTransition() {
        self.transitioningDelegate = _transition
        _transition.wireTo(viewController: ByvMenuNav.instance)
        _transition.newStatusBarStyle = _statusBarStyle
    }
    
    func barButton() -> UIBarButtonItem {
        return _barButtonItem
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    @IBAction func showCloseModal(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "modalNavVC")
        ByvMenuNav.instance?.showModal(vc, fromMenu: self)
        
    }
    
    @IBAction func changeToCloseAsRoot(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "modalVC")
        ByvMenuNav.setRoot(viewController:vc, fromMenu: self)
    }
    
    @IBAction func changeToTran(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuSettingsVC")
        ByvMenuNav.setRoot(viewController:vc, fromMenu: self)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
