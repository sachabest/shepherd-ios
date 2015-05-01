//
//  DiagnosisViewController.swift
//  Shepherd
//
//  This class is an extended class of a SectionedParseTableViewController that displays a list of diagnoses
//  sorted alphabetically and sectioned by beginning letter.
//
//  Created by Rohun Bansal on 3/29/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import UIKit

class DiagnosisViewController: SectionedParseTableViewController {
    var complaint: PFObject!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Diagnosis"
        self.textKey = "Name"
        self.sectionKey = "Category"
    }
    
    override func addSearchToQuery(query: PFQuery) -> PFQuery {
        if(self.complaint != nil){
            query.whereKey("Complaint", equalTo: self.complaint)
        }
        
        return query
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "treatment" {
            let controller = segue.destinationViewController as! TreatmentViewController
            
            if self.searchDisplayController!.active {
                if let indexPath = self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow() {
                    controller.diagnosis = self.objectAtIndexPath(indexPath) as PFObject!
                }
            } else {
                if let indexPath = self.tableView.indexPathForSelectedRow(){
                    controller.diagnosis = self.objectAtIndexPath(indexPath) as PFObject!
                }
            }
        }
    }
}