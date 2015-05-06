//
//  ChiefComplaintViewController.swift
//  Shepherd
//
//  The UIViewController that manages the main app screen that allows users to
//  select a Chief Complaint and, if not signed in, prompts them to either sign
//  in or make an account.
//
//  Created by Rohun Bansal on 3/24/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

class ChiefComplaintViewController: SectionedParseTableViewController  {
    var currentUser: PFUser? = nil

    // setup variables for the SectionedParseTableViewController
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Complaint"
        self.textKey = "Name"
        self.sectionKey = "Category"
    }

    // if user not signed in, present registration/sign in view
    override func viewDidAppear(animated: Bool) {
        self.currentUser = PFUser.currentUser()
        
        if self.currentUser == nil {
            var logInController = PFLogInViewController()
            logInController.delegate = self
            logInController.signUpController?.delegate = self
            logInController.fields = (PFLogInFields.UsernameAndPassword
                | PFLogInFields.LogInButton
                | PFLogInFields.SignUpButton
                | PFLogInFields.PasswordForgotten)
            self.presentViewController(logInController, animated:animated, completion: nil)
        }
    }
    
    // MARK: - Segues
    
    // when segue triggerd to the diagnosis or not question, pass along the chief complaint
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show" {
            let controller = segue.destinationViewController as! DiagnosisQuestionViewController
            
            if self.searchDisplayController!.active {
                if let indexPath = self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow() {
                    controller.detailItem = self.objectAtIndexPath(indexPath) as PFObject!
                }
            } else {
                if let indexPath = self.tableView.indexPathForSelectedRow(){
                    controller.detailItem = self.objectAtIndexPath(indexPath) as PFObject!
                }
            }
        }
    }
}

// handle user login success/failure from Parse
extension ChiefComplaintViewController : PFLogInViewControllerDelegate {
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser) -> Void {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void {
        // NOOP
    }
}

// handle user registration success/failure from Parse
extension ChiefComplaintViewController: PFSignUpViewControllerDelegate {
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) -> Void {
        // NOOP
    }
}