//
//  DetailViewController.swift
//  Shepherd
//
//  Once a user has selected a Chief Complain, this view controller asks
//  the user if they have already received a diagnosis, directing them to 
//  the correct view (diagnoses or tests) depending on their answer.
//
//  Created by Rohun Bansal on 3/24/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class DiagnosisQuestionViewController: UIViewController {
    var detailItem: PFObject! {
        didSet {
            // Update the view.
            self.title = "Complaint: " + (self.detailItem["Name"] as! String!)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "yesDiagnosis" {
            var diagnosisViewController : DiagnosisViewController = segue.destinationViewController as! DiagnosisViewController
            diagnosisViewController.complaint = self.detailItem as PFObject?
        } else if segue.identifier == "noDiagnosis" {
            var testsViewController : TestsViewController = segue.destinationViewController as! TestsViewController
            testsViewController.complaint = self.detailItem as PFObject?
        }
    }
}