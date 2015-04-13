//
//  PatientPlan.swift
//  Shepherd
//
//  Created by Reuben on 4/12/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

private let _PatientPlanSharedInstance = PatientPlan()

class PatientPlan {
    
    var treatments : [PFObject] = []
    
    class var sharedInstance: PatientPlan {
        return _PatientPlanSharedInstance
    }
    
}
