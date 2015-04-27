//
//  PrescriptionSummaryViewController.swift
//  Shepherd
//
//  This class is a UIViewController that adds a treatment to a patient's list of treatments when the
//  button linked to the addToPlan function is clicked.
//
//  Created by Rohun Bansal on 4/12/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class PrescriptionSummaryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var prescriptionLabel: UILabel!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var quantityDisplay: UITextField!
    
    var variants: [PFObject]!
    
    var quantity: Int! {
        didSet {
            // Update the view.
            self.quantityDisplay.text = quantity.description
        }
    }
    
    var prescription: PFObject!
    
    @IBAction func addToPlan(sender: UIButton) {
        var prescriptionBundle = Prescription()
        prescriptionBundle.prescription = self.prescription
        prescriptionBundle.quantity = self.quantity
        
        if self.variants == nil || self.variants.count == 0 {
            prescriptionBundle.variant = nil
        } else {
            prescriptionBundle.variant = self.variants[self.picker.selectedRowInComponent(0)]
        }

        let alert = UIAlertView()
        if !PatientPlan.sharedInstance.containsPrescription(prescriptionBundle) {
            PatientPlan.sharedInstance.addPrescription(prescriptionBundle)
            
            alert.title = "Prescription Added"
            alert.message = "Prescription has been added to Patient Plan"
        } else {
            alert.title = "Prescription Not Added"
            alert.message = "Prescription already exists in Patient Plan"
        }
        
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        self.quantity = Int(sender.value)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.prescriptionLabel.text = self.prescription["Name"] as! String!
        self.quantity = 1

        var relation = self.prescription["Prescriptions"] as! PFRelation!
        if relation != nil {
            var query: PFQuery! = relation.query()
            
            query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
                if let foundObjects = objects as? [PFObject] {
                    self.variants = foundObjects
                    self.picker.reloadAllComponents()
                }
            })
        }
    }
    
    // UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.variants == nil || self.variants.count == 0 {
            return 1
        }
        
        return self.variants.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if self.variants == nil || self.variants.count == 0 {
            return "Default | $" + (self.prescription["Price"] as! Double!).format(".2")
        }
        
        if let variant = self.variants[row] as PFObject? {
            return (variant["Amount"] as! Int!).description + " " + (variant["Units"] as! String!) + " | $" + (variant["Price"] as! Double!).format(".2")
        }
        
        return "Default"
    }
}