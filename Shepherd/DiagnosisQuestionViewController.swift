//
//  DetailViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 3/24/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import UIKit
import Parse

class DiagnosisQuestionViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: PFObject! {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("timeStamp")!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "yesDiagnosis"{
            var diagnosisViewController : DiagnosisViewController = segue.destinationViewController as DiagnosisViewController
            diagnosisViewController.complaint = self.detailItem as PFObject?
        }else if segue.identifier == "noDiagnosis"{
            var testsViewController : TestsViewController = segue.destinationViewController as TestsViewController
            testsViewController.complaint = self.detailItem as PFObject?
        }
    }
}

