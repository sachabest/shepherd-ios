//
//  TreatmentSummaryViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 4/12/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class TreatmentSummaryViewController: UIViewController{
    var treatment: PFObject!
     @IBOutlet var treatmentLabel: UILabel!
    
    @IBAction func addToPlan(sender: UIButton) {
        println("adding to plan")
        println(self.treatment)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.treatmentLabel.text = self.treatment["Name"] as! String!
    }
}