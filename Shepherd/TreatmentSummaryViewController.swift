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
        if !contains(PatientPlan.sharedInstance.treatments, self.treatment){
            PatientPlan.sharedInstance.treatments.append(self.treatment)
            
            let alert = UIAlertView()
            alert.title = "Treatment Added"
            alert.message = "Treatment has been added to Patient Plan"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }else{
            let alert = UIAlertView()
            alert.title = "Treatment Not Added"
            alert.message = "Treatment already exists in Patient Plan"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.treatmentLabel.text = self.treatment["Name"] as! String!
    }
}