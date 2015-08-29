//
//  TreatmentViewController.swift
//  Shepherd
//
//  This class is an extended class of a SectionedParseTableViewController that displays a list of treatments
//  sorted alphabetically and sectioned by beginning letter.
//
//  Created by Rohun Bansal on 4/6/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

class TreatmentViewController: SectionedParseTableViewController{
    var diagnosis: PFObject!
    let availableSortOptions = ["Name", "Price"]
    
    // setup variables for SectionedParseTableViewController
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Treatment"
        self.textKey = "Name"
        self.sectionKey = "Category"
    }
    
    // if diagnosis set, filter only to treatments related to it
    override func addSearchToQuery(query: PFQuery) -> PFQuery {
        if(self.diagnosis != nil){
            query.whereKey("Diagnosis", equalTo: self.diagnosis)
        }
        
        return query
    }
    
    // custom formatting for cells in this view
    override func prepareCell(cell: UITableViewCell, object: PFObject) -> UITableViewCell {
        cell.textLabel?.text = object[self.textKey!] as! String!
        if !(object["Price"] is NSNull) {
            cell.detailTextLabel?.text = "$" + (object["Price"] as! Double).format(".2")
        }
        return cell
    }
    
    // allows users to select how they would like to sort the treatment list
    @IBAction func sortList(sender: UIButton) {
        UIActionSheet.showInView(self.view, withTitle: "Select Sort Method", cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,
            otherButtonTitles: self.availableSortOptions, tapBlock: {(actionSheet: UIActionSheet, buttonIndex: Int) in
                self.sortKey = actionSheet.buttonTitleAtIndex(buttonIndex)
                self.loadObjects()
        })
    }
    
    // when treatment selected, prepare prescription summary with the selected treatment
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