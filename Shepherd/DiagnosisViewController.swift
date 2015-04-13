//
//  DiagnosisViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 3/29/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse
import UIKit

class DiagnosisViewController: SectionedParseTableViewController{
    var complaint: PFObject!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Diagnosis"
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
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "treatment" {
            if let indexPath = self.tableView.indexPathForSelectedRow(){
                let object = self.objectAtIndexPath(indexPath) as PFObject!
                let controller = segue.destinationViewController as! TreatmentViewController
                controller.diagnosis = object
            }
        }
    }
}

extension DiagnosisViewController: UISearchBarDelegate{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        self.searchTerm = searchText
        self.loadObjects()
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        self.searchTerm = nil
        self.loadObjects()
    }
}