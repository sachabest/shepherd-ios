//
//  SectionedParseTableViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 4/12/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class SectionedParseTableViewController: UITableViewController, UITableViewDataSource{
    var searchTerm: String!
    var searchField: String = "canonicalName"
    
    var parseClassName : String = ""
    var firstLoad : Bool = true
    var objects : [PFObject] = []
    var textKey: String!
    var sectionKey: String!
    
    var sections: [Section] = []
    var sectionNames: [String: Section] = [:]
    
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
    
    func addDynamicSearchToQuery(query: PFQuery) -> PFQuery{
        if(self.searchTerm != nil){
            println(self.searchTerm)
            query.whereKey(self.searchField, containsString: self.searchTerm)
        }
        
        return query
    }
    
    func addSortsToQuery(query: PFQuery) -> PFQuery {
        query.orderByAscending(self.sectionKey)
        query.orderByAscending(self.textKey!)
        
        return query
    }
    
    func loadObjects(){
        var query = self.queryForTable()
        query = self.addDynamicSearchToQuery(query)
        query = self.addSortsToQuery(query)
        
        query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
            if let foundObjects = objects as? [PFObject] {
                self.objects.removeAll(keepCapacity: true)
                self.objects.extend(foundObjects)
                
                if(self.sectionKey != nil){
                    self.sectionNames.removeAll(keepCapacity: true)
                    self.sections.removeAll(keepCapacity: true)
                    
                    for object in self.objects{
                        var sectionName = object[self.sectionKey as String!] as! String!
                        var sectionList = self.sectionNames[sectionName] as Section?
                        
                        if(sectionList == nil){
                            sectionList = Section()
                            sectionList!.name = sectionName
                            self.sections.append(sectionList!)
                            self.sectionNames[sectionName] = sectionList
                        }
                        
                        sectionList!.objects.append(object)
                    }
                }
                
                println(self.sections.count)
                self.tableView.reloadData()
            }
        })
    }
    
    func objectsWillLoad() {
        if (self.firstLoad) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        }
        self.refreshLoadingView()
    }
    
    
    func refreshLoadingView(){
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == self.tableView && self.searchTerm != nil){
            return 0
        }
        print("num sections: ")
        println(self.sections.count)
        return self.sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableView && self.searchTerm != nil){
            return 0
        }
        
        print("section: ")
        println( self.sections[section].objects.count)
        return self.sections[section].objects.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].name
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> PFObject{
        return self.sections[indexPath.section].objects[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! UITableViewCell!
        if(cell == nil){
            cell = PFTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        
        var object = self.objectAtIndexPath(indexPath)
        
        cell = self.prepareCell(cell, object: object)
        
        return cell
    }
    
    func prepareCell(cell: UITableViewCell, object: PFObject) -> UITableViewCell{
        cell.textLabel?.text = object[self.textKey!] as! String!
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // NOOP
    }
}