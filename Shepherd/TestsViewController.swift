//
//  TestsViewController.swift
//  Shepherd
//
//  TODO
//
//  Created by Rohun Bansal on 3/29/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class TestsViewController: SectionedParseTableViewController {
    var complaint: PFObject!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Test"
        self.textKey = "Name"
        self.sectionKey = "Category"
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName)
        if(self.complaint != nil){
            query.whereKey("Complaint", equalTo: self.complaint)
        }

        return query
    }
    
    override func prepareCell(cell: UITableViewCell, object: PFObject) -> UITableViewCell {
        cell.textLabel?.text = object[self.textKey!] as! String!
        cell.detailTextLabel?.text = "$" + (object["Price"] as! Double).format(".2")
        
        return cell

    }
    
    @IBAction func sortList(sender: UIButton) {
        UIActionSheet.showInView(self.view, withTitle: "Select Sort Method", cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,
            otherButtonTitles: ["Name", "Price"], tapBlock: {(actionSheet: UIActionSheet, buttonIndex: Int) in
                self.sortKey = actionSheet.buttonTitleAtIndex(buttonIndex)
                self.loadObjects()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "summary" {
            let controller = segue.destinationViewController as! PrescriptionSummaryViewController
            
            if self.searchDisplayController!.active {
                if let indexPath = self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow() {
                    controller.prescription = self.objectAtIndexPath(indexPath) as PFObject!
                }
            } else {
                if let indexPath = self.tableView.indexPathForSelectedRow(){
                    controller.prescription = self.objectAtIndexPath(indexPath) as PFObject!
                }
            }
        }
    }
}