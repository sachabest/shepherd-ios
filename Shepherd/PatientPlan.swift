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

private let _PatientPlanSharedInstance = PatientPlan()

class PatientPlan {
    var prescriptions : [Prescription] = []
    
    // provides the singleton PatientPlan
    class var sharedInstance: PatientPlan {
        return _PatientPlanSharedInstance
    }
    
    // allows for Prescriptions to be added to the Patient Plan
    func addPrescription(prescription: Prescription) {
        self.prescriptions.append(prescription)
    }
    
    // checks if the Patient Plan contains the Prescription (by criteria of same treatment/test and/or variant)
    func containsPrescription(prescription: Prescription) -> Bool {
        return contains(self.prescriptions, prescription)
    }
    
    // removes all Prescriptions from the Patient Plan
    func clearAll() {
        self.prescriptions.removeAll(keepCapacity: true)
    }
    
    // number of Prescriptions in Patient Plan
    func countPrescriptions() -> Int {
        return self.prescriptions.count
    }
    
    // whether the Patient Plan is empty or not
    func isEmpty() -> Bool {
        return self.countPrescriptions() == 0
    }
}

