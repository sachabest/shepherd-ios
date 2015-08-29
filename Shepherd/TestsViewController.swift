//
//  TestsViewController.swift
//  Shepherd
//
//  This class is an extended class of a SectionedParseTableViewController that displays a list of tests
//  sorted alphabetically and sectioned by beginning letter.
//
//  Created by Rohun Bansal on 3/29/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

class TestsViewController: SectionedParseTableViewController {
    var complaint: PFObject!
    
    // setup variables for SectionedParseTableViewController
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Test"
        self.textKey = "Name"
        self.sectionKey = "Category"
    }
    
    // filter only tests that match chief complain, if set
    override func addSearchToQuery(query: PFQuery) -> PFQuery {
        if(self.complaint != nil){
            query.whereKey("Complaint", equalTo: self.complaint)
        }
        
        return query
    }
    
    // override to provide cell styling and formatting
    override func prepareCell(cell: UITableViewCell, object: PFObject) -> UITableViewCell {
        cell.textLabel?.text = object[self.textKey!] as! String!
        if !(object["Price"] is NSNull) {
            cell.detailTextLabel?.text = "$" + (object["Price"] as! Double).format(".2")
        }
        return cell

    }
    
    // allow user to select how they would like to sort the list
    @IBAction func sortList(sender: UIButton) {
        UIActionSheet.showInView(self.view, withTitle: "Select Sort Method", cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,
            otherButtonTitles: ["Name", "Price"], tapBlock: {(actionSheet: UIActionSheet, buttonIndex: Int) in
                self.sortKey = actionSheet.buttonTitleAtIndex(buttonIndex)
                self.loadObjects()
        })
    }
    
    // when test selected, prepare the prescription summary with the correct test
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