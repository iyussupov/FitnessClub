//
//  Classes.swift
//  FitnessClub
//
//  Created by Dev1 on 2/12/16.
//  Copyright © 2016 FXoffice. All rights reserved.
//

import Foundation
import Parse

class Classes {
    
    private var _title: String?
    
    private var _classImg: PFFile?
    
    private var _trainers: String?
    
    private var _classDesc: String?
    
    private var _scheduleMon: String?
    
    private var _classId: String!
    
    var title: String? {
        return _title
    }
    
    var classDesc: String? {
        return _classDesc
    }
    
    var classImg: PFFile? {
        return _classImg
    }
    
    var trainers: String? {
        return _trainers
    }
    
    var scheduleMon: String? {
        return _scheduleMon
    }
    
    var classId: String? {
        return _classId
    }
    

    
    init (title: String?, classDesc: String?, classImg: PFFile?, trainers: String?, scheduleMon: String? ) {
        self._title = title
        self._classDesc = classDesc
        self._classImg = classImg
        self._trainers = trainers
        self._scheduleMon = scheduleMon
    }
    
    init(classId: String, dictionary: PFObject) {
        
        self._classId = classId
        
        if let title = dictionary["title"] as? String {
            self._title = title
        }
        
        if let classDesc = dictionary["classDesc"] as? String {
            self._classDesc = classDesc
        }
        
        if let classImg = dictionary["classImage"] as? PFFile {
            self._classImg = classImg
        }
        
        if let trainers = dictionary["trainers"]["name"] as? String {
            self._trainers = trainers
        }
        
        if let scheduleMon = dictionary["scheduleMon"] as? String {
            self._scheduleMon = scheduleMon
        }
        
    }
    
    
    
    
    
}
