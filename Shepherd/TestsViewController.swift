//
//  TestsViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 3/29/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class TestsViewController: PFQueryTableViewController{
    var complaint: PFObject!
    var searchTerm: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Test"
        self.textKey = "Name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func queryForTable() -> PFQuery! {
        var query = PFQuery(className: self.parseClassName)
        if(self.complaint != nil){
            query.whereKey("Complaint", equalTo: self.complaint)
        }
        if(self.searchTerm != nil){
            query.whereKey("canonicalName", containsString: self.searchTerm)
        }
        
        query.orderByAscending(self.textKey)
        return query
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        var cellId = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as PFTableViewCell!
        if(cell == nil){
            cell = PFTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = object[self.textKey] as String!
        cell?.detailTextLabel?.text = "$" + (object["Price"] as Double).format(".2")
        
        return cell
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