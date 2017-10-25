//
//  ProfileTableViewController.swift
//  Key2House
//
//  Created by Xiao on 04/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import os.log




class ProfileTableViewController: UITableViewController {

    //var profiles : [Profile] = []
    var manager = ManagerSingleton.shared
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
      //profiles = manager.allProfiles

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return manager.allProfiles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell else{
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let p = manager.allProfiles[indexPath.row]
        cell.profileNameLabel.text = p.name!
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
        }
    }

    @IBAction func unwindToProfileList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ProfileConfigurationViewController, let profile = sourceViewController.profile {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    
                    manager.allProfiles[selectedIndexPath.row] = profile
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {

                    let newIndexPath = IndexPath(row: manager.allProfiles.count, section: 0)
                    
                    //profiles.append(profile)
                    manager.allProfiles.append(profile)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
    

            //Save the meals.
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding new profile.", log: OSLog.default, type: .debug)
            
        case "ShowProfile":
            guard let profileDetailViewController = segue.destination as? ProfileConfigurationViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedProfileCell = sender as? ProfileTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "nill")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedProfileCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedProfile = manager.allProfiles[indexPath.row]
            profileDetailViewController.profile = selectedProfile
            os_log("edit  profile.", log: OSLog.default, type: .debug)
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "Nill")")
        }
    }
    
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
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
