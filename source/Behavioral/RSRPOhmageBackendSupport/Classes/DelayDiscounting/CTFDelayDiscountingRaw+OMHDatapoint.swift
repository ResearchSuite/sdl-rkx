//
//  CTFDelayDiscountingRaw+OMHDatapoint.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import OMHClient

extension CTFDelayDiscountingRaw: OMHDataPointBuilder {
    
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
        return OMHSchema(name: "DelayDiscountingRaw", version: "1.0", namespace: "Cornell")
    }
    
    open var body: [String: Any] {
        return [
            "variable_label": self.variableLabel,
            "now_array": self.nowArray,
            "later_array": self.laterArray,
            "choice_array": self.choiceArray,
            "times": self.times
        ]
    }

}
