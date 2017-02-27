//
//  CTFPAMMultipleRaw+OHMDataPoint.swift
//  Pods
//
//  Created by James Kizer on 2/26/17.
//
//

import Foundation
import OMHClient

extension CTFPAMMultipleRaw: OMHDataPointBuilder {
    
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
        return OMHSchema(name: "PAMMultipleRaw", version: "1.0", namespace: "Cornell")
    }
    
    open var body: [String: Any] {

        return [
            "effective_time_frame": [
                "date_time": self.stringFromDate(self.creationDateTime)
            ],
            "selected": self.pamChoices
        ]
        
    }
    
}
