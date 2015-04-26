//
//  PrescriptionSummaryViewController.swift
//  Shepherd
//
//  TODO
//
//  Created by Rohun Bansal on 4/12/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class PrescriptionSummaryViewController: UIViewController {
    @IBOutlet var prescriptionLabel: UILabel!
    
    var prescription: PFObject!
    
    @IBAction func addToPlan(sender: UIButton) {
        let alert = UIAlertView()
        
        if !PatientPlan.sharedInstance.containsPrescription(self.prescription) {
            PatientPlan.sharedInstance.addPrescription(self.prescription)
            
            alert.title = "Prescription Added"
            alert.message = "Prescription has been added to Patient Plan"
        } else {
            alert.title = "Prescription Not Added"
            alert.message = "Prescription already exists in Patient Plan"
        }
        
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.prescriptionLabel.text = self.prescription["Name"] as! String!
    }
}