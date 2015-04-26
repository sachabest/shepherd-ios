//
//  TreatmentSummaryViewController.swift
//  Shepherd
//
//  TODO
//
//  Created by Rohun Bansal on 4/12/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class TreatmentSummaryViewController: UIViewController {
    @IBOutlet var treatmentLabel: UILabel!
    
    var treatment: PFObject!
    
    @IBAction func addToPlan(sender: UIButton) {
        let alert = UIAlertView()
        
        if !PatientPlan.sharedInstance.containsTreatment(self.treatment) {
            PatientPlan.sharedInstance.addTreatment(self.treatment)
            
            alert.title = "Treatment Added"
            alert.message = "Treatment has been added to Patient Plan"
        } else {
            alert.title = "Treatment Not Added"
            alert.message = "Treatment already exists in Patient Plan"
        }
        
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.treatmentLabel.text = self.treatment["Name"] as! String!
    }
}