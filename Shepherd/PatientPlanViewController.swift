//
//  PatientPlanViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 4/13/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Foundation

class PatientPlanViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalCost: UILabel!
    
    var tableViewController: PatientPlanTableViewController = PatientPlanTableViewController()
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.delegate = self.tableViewController
        self.tableView.dataSource = self.tableViewController
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            
            var cost : Double = 0
            for object in PatientPlan.sharedInstance.treatments {
                cost += object["Price"] as! Double!
            }
            
            self.totalCost.text = cost.format(".2")
        })
    }
    
    class PatientPlanTableViewController: UITableViewController, UITableViewDataSource {
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return PatientPlan.sharedInstance.treatments.count
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cellId = "Cell"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! UITableViewCell!
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            }
            
            var object = PatientPlan.sharedInstance.treatments[indexPath.row]
            
            cell.textLabel?.text = object["Name"] as! String!
            cell.detailTextLabel?.text = "$" + (object["Price"] as! Double).format(".2")
            
            return cell
        }
    }
}