//
//  PatientPlanViewController.swift
//  Shepherd
//
//  PatientPlanViewController is a UIViewController that displays the list of treatments/tests the patient ordered.
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
        self.updateUI()
    }
    
    func updateUI() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            
            var cost : Double = 0
            for object in PatientPlan.sharedInstance.prescriptions {
                cost += object["Price"] as! Double!
            }
            
            self.totalCost.text = cost.format(".2")
        })
    }
    
    func constructShareText() -> String {
        var textToShare = "<html><body><p><h1>Patient Plan</h1></p>" +
        "<table style=\"border-collapse: collapse; border: 1px solid black\"><thead><tr><th style=\"text-align: left; border: 1px solid black; padding: .25em\">Prescription</th><th style=\"text-align: left; border: 1px solid black; padding: .25em\">Type</th><th style=\"text-align: right; border: 1px solid black; padding: .25em\">Cost</th></tr></thead>"
        
        for prescription in PatientPlan.sharedInstance.prescriptions {
            textToShare += "<tr><td style=\"text-align: left; border: 1px solid black; padding: .25em\">" + (prescription["Name"] as! String!) + "</td><td style=\"text-align: left; border: 1px solid black; padding: .25em\">" + prescription.parseClassName + "</td><td style=\"text-align: right; border: 1px solid black; padding: .25em\">" + ("$" + (prescription["Price"] as! Double).format(".2")) + "</td></tr>"
        }
        
        textToShare += "<tbody></tbody></table>"
        
        textToShare += "<br>Created with Shepherd, a <a href=\"https://www.seas.upenn.edu/~cdmurphy/cis350/\">Penn CIS 350</a> Project by <a href=\"http://rohunbansal.com/\">Rohun Bansal</a>, <a href=\"https://www.linkedin.com/pub/hannah-cutler/83/743/b6b\">Hannah Cutler</a>, and <a href=\"https://www.linkedin.com/pub/reuben-abraham/98/482/9a3\">Reuben Abraham</a></body></html>"
        
        return textToShare
    }
    
    @IBAction func clearButtonClicked(sender: UIButton) {
        let alertController = UIAlertController(title: "Clear Patient Plan?", message: "Cannot be undone.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Clear", style: .Destructive) { (action) in
            PatientPlan.sharedInstance.clearAll()
            self.updateUI()
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonClicked(sender: UIButton) {
        if PatientPlan.sharedInstance.isEmpty() {
            let alert = UIAlertView()
            alert.title = "Patient Plan Empty"
            alert.message = "There are no prescriptions in the Patient Plan. Please add some before sharing."
            alert.addButtonWithTitle("Ok")
            alert.show()
            
            return
        }
        
        var textToShare = self.constructShareText()
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
        // Excluded Activities Codes
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    class PatientPlanTableViewController: UITableViewController, UITableViewDataSource {
        let cellId = "Cell"
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return PatientPlan.sharedInstance.countPrescriptions()
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCellWithIdentifier(self.cellId) as! UITableViewCell!
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            }
            
            var object = PatientPlan.sharedInstance.prescriptions[indexPath.row]
            
            cell.textLabel?.text = object["Name"] as! String!
            cell.detailTextLabel?.text = "$" + (object["Price"] as! Double).format(".2")
            
            return cell
        }
    }
}