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
    
    func addTreatment(treatment: PFObject) {
        self.treatments.append(treatment)
    }
    
    func containsTreatment(treatment: PFObject) -> Bool {
        return contains(self.treatments, treatment)
    }
    
    func clearAll() {
        self.treatments.removeAll(keepCapacity: true)
    }
    
    func countTreatments() -> Int {
        return self.treatments.count
    }
    
    func isEmpty() -> Bool {
        return self.countTreatments() == 0
    }
}
