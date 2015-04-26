//
//  ChiefComplaintViewController.swift
//  Shepherd
//
//  The UIViewController that manages the main app screen that allows users to select a Chief Complaint and,
//  if not signed in, prompts them to either sign in or make an account.
//
//  Created by Rohun Bansal on 3/24/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

class ChiefComplaintViewController: SectionedParseTableViewController  {
    var currentUser: PFUser? = nil

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Complaint"
        self.textKey = "Name"
        self.sectionKey = "Category"
    }

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.objectAtIndexPath(indexPath) as PFObject!
                let controller = segue.destinationViewController as! DiagnosisQuestionViewController
                controller.detailItem = object
            }
        }
    }
}


extension ChiefComplaintViewController : PFLogInViewControllerDelegate {
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser) -> Void {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void {
        // NOOP
    }
}


extension ChiefComplaintViewController: PFSignUpViewControllerDelegate {
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) -> Void {
        // NOOP
    }
}