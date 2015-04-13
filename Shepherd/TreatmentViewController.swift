//
//  TreatmentViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 4/6/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class TreatmentViewController: SectionedParseTableViewController{
    var diagnosis: PFObject!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Treatment"
        self.textKey = "Name"
        self.sectionKey = "Category"
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName)
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
        UIActionSheet.showInView(self.view, withTitle: "Select Sort Method", cancelButtonTitle: "Cancel", destructiveButtonTitle: nil
            , otherButtonTitles: ["Name", "Price"], tapBlock: {(actionSheet: UIActionSheet, buttonIndex: Int) in
                self.sortKey = actionSheet.buttonTitleAtIndex(buttonIndex)
                self.loadObjects()
        })
    }
}

extension TreatmentViewController: UISearchBarDelegate{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        self.searchTerm = searchText
        self.loadObjects()
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        self.searchTerm = nil
        self.loadObjects()
    }
}