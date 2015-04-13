//
//  TestsViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 3/29/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class TestsViewController: SectionedParseTableViewController{
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
       //
    }
}

extension TestsViewController: UISearchBarDelegate{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        self.searchTerm = searchText
        self.loadObjects()
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        self.searchTerm = nil
        self.loadObjects()
    }
}