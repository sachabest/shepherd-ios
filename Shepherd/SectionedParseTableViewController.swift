//
//  SectionedParseTableViewController.swift
//  Shepherd
//
//  TODO
//
//  Created by Rohun Bansal on 4/12/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class SectionedParseTableViewController: UITableViewController, UITableViewDataSource, UISearchBarDelegate {
    var parseClassName : String = ""
    var textKey: String!
    var sortKey: String!
    var searchField: String = "canonicalName"
    var sectionKey: String!
    
    var searchTerm: String!
    
    var objects: [PFObject] = []
    var filtered: [PFObject] = []
    
    var sections: [Section] = []
    var sectionNames: [String: Section] = [:]
    
    let cellId = "Cell"
    
    class Section {
        var objects: [PFObject] = []
        var name: String!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadObjects()
    }
    
    func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName)
        
        query.orderByAscending("createdAt")
        return query
    }
    
    func addSearchToQuery(query: PFQuery) -> PFQuery {
        if self.searchTerm != nil {
            query.whereKey(self.searchField, containsString: self.searchTerm)
        }
        
        return query
    }
    
    func addSortsToQuery(query: PFQuery) -> PFQuery {
        query.orderByAscending(self.sectionKey)
        
        if self.sortKey != nil {
            query.orderByAscending(self.sortKey!)
        } else {
            // when no other sort key has been specified, use the display text as key
            query.orderByAscending(self.textKey!)
        }
        
        return query
    }
    
    func createSections(sourceObjects: [PFObject]) {
        if(self.sectionKey != nil){
            self.sectionNames.removeAll(keepCapacity: true)
            self.sections.removeAll(keepCapacity: true)
            
            for object in sourceObjects{
                var sectionName = object[self.sectionKey as String!] as! String!
                var sectionList = self.sectionNames[sectionName] as Section?
                
                if sectionList == nil {
                    sectionList = Section()
                    sectionList!.name = sectionName
                    self.sections.append(sectionList!)
                    self.sectionNames[sectionName] = sectionList
                }
                
                sectionList!.objects.append(object)
            }
        }
    }
    
    func loadObjects() {
        var query = self.queryForTable()
        query = self.addSearchToQuery(query)
        query = self.addSortsToQuery(query)
        
        query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
            if let foundObjects = objects as? [PFObject] {
                self.objects.removeAll(keepCapacity: true)
                self.objects.extend(foundObjects)
                
                self.createSections(self.objects)
                
                self.tableView.reloadData()
            }
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].objects.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].name
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        var indexTitles : [String] = []
        
        for section in self.sections {
            var letterString = (section.name as NSString).substringToIndex(1)
            indexTitles.append(letterString)
        }
        
        return indexTitles
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> PFObject {
        return self.sections[indexPath.section].objects[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellId) as! UITableViewCell!
        
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: self.cellId)
        }
        
        var object = self.objectAtIndexPath(indexPath)
        
        cell = self.prepareCell(cell, object: object)
        
        return cell
    }
    
    func prepareCell(cell: UITableViewCell, object: PFObject) -> UITableViewCell {
        cell.textLabel?.text = object[self.textKey!] as! String!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // NOOP
    }
    
    // UISearchBarDelegate methods
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // case-insensitive search on self.searchField
        
        self.filtered = self.objects.filter({(object: PFObject) -> Bool in
            let stringToSearch: NSString = object[self.searchField] as! String!
            let range = stringToSearch.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })

        self.createSections(self.filtered)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.createSections(self.objects)
    }
}