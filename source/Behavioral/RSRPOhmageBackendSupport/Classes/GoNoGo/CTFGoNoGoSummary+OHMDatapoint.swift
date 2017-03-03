//
//  CTFGoNoGoSummary+OHMDatapoint.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/29/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import OMHClient

extension CTFGoNoGoSummary: OMHDataPointBuilder {
    
    open var creationDateTime: Date {
        return self.startDate ?? Date()
    }
    
    open var dataPointID: String {
        return self.uuid.uuidString
    }
    
    open var acquisitionModality: OMHAcquisitionProvenanceModality? {
        return .Sensed
    }
    
    open var acquisitionSourceCreationDateTime: Date? {
        return self.startDate
    }
    
    open var acquisitionSourceName: String? {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
    }
    
    open var schema: OMHSchema {
        return OMHSchema(name: "GoNoGoSummary", version: "1.1", namespace: "Cornell")
    }
    
    open var body: [String: Any] {
        return [
            "total": self.totalSummary.toDict(),
            "firstThird": self.firstThirdSummary.toDict(),
            "middleThird": self.middleThirdSummary.toDict(),
            "lastThird": self.lastThirdSummary.toDict()
        ]
    }

}
