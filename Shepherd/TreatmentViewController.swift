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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Treatment"
        self.textKey = "Name"
        self.sectionKey = "Category"
    }
    
    override func addSearchToQuery(query: PFQuery) -> PFQuery {
        if(self.diagnosis != nil){
            query.whereKey("Diagnosis", equalTo: self.diagnosis)
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
            otherButtonTitles: self.availableSortOptions, tapBlock: {(actionSheet: UIActionSheet, buttonIndex: Int) in
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