//
//  PatientPlan.swift
//  Shepherd
//
//  This class is a singleton design pattern class that is used to organize
//  the treatments selected for any given patient
//
//  Created by Reuben on 4/12/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

import Parse

private let _PatientPlanSharedInstance = PatientPlan()

class PatientPlan {
    var prescriptions : [Prescription] = []
    
    class var sharedInstance: PatientPlan {
        return _PatientPlanSharedInstance
    }
    
    func addPrescription(prescription: Prescription) {
        self.prescriptions.append(prescription)
    }
    
    func containsPrescription(prescription: Prescription) -> Bool {
        return contains(self.prescriptions, prescription)
    }
    
    func clearAll() {
        self.prescriptions.removeAll(keepCapacity: true)
    }
    
    func countPrescriptions() -> Int {
        return self.prescriptions.count
    }
    
    func isEmpty() -> Bool {
        return self.countPrescriptions() == 0
    }
}

