//
//  MasterViewController.swift
//  Shepherd
//
//  Created by Rohun Bansal on 3/24/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse


class ChiefComplaintViewController: PFQueryTableViewController, UISearchDisplayDelegate  {
    var currentUser: PFUser? = nil
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
        self.parseClassName = "Complaint"
        self.textKey = "Name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        self.currentUser = PFUser.currentUser()
        if self.currentUser != nil {
            
        } else {
            var logInController = PFLogInViewController()
            logInController.delegate = self
            logInController.signUpController.delegate = self
            logInController.fields = (PFLogInFields.UsernameAndPassword
                | PFLogInFields.LogInButton
                | PFLogInFields.SignUpButton
                | PFLogInFields.PasswordForgotten)
            self.presentViewController(logInController, animated:animated, completion: nil)
        }
    }

    override func queryForTable() -> PFQuery! {
        var query = PFQuery(className: self.parseClassName)

        if(self.searchTerm != nil){
            query.whereKey("canonicalName", containsString: self.searchTerm.lowercaseString)
        }
        
        query.orderByAscending(self.textKey)
        return query
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        var cellId = "Cell"
    
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as PFTableViewCell!
        if(cell == nil){
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = object[self.textKey] as String!

        return cell
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show" {
            if let indexPath = self.tableView.indexPathForSelectedRow(){
                let object = self.objectAtIndexPath(indexPath) as PFObject!
                let controller = segue.destinationViewController as DiagnosisQuestionViewController
                controller.detailItem = object
            }
        }
    }
}


extension ChiefComplaintViewController : PFLogInViewControllerDelegate {
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser!) -> Void {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void {
        // NOOP
    }
}

extension ChiefComplaintViewController: PFSignUpViewControllerDelegate{
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) -> Void {
        // NOOP
    }
}

extension ChiefComplaintViewController: UISearchBarDelegate{
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.searchTerm = searchString
        self.loadObjects()
        return true
    }
}
