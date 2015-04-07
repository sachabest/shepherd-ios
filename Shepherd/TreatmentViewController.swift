//
//  TreatmentViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 4/6/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class TreatmentViewController: PFQueryTableViewController{
    var diagnosis: PFObject!
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
        self.parseClassName = "Treatment"
        self.textKey = "Name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func queryForTable() -> PFQuery! {
        var query = PFQuery(className: self.parseClassName)
        if(self.diagnosis != nil){
            query.whereKey("Diagnosis", equalTo: self.diagnosis)
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
        cell?.detailTextLabel?.text = "$" + String(object["Price"] as Int)
        
        return cell
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