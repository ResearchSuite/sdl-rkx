//
//  CTFPAMRaw+OHMDataPoint.swift
//  Pods
//
//  Created by James Kizer on 2/26/17.
//
//

import Foundation
import OMHClient

extension CTFPAMRaw: OMHDataPointBuilder {
    
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
        return OMHSchema(name: "photographic-affect-meter-scores", version: "1.0", namespace: "Cornell")
    }
    
    open var body: [String: Any] {
        
        var returnBody = self.pamChoice
        returnBody["effective_time_frame"] = [
            "date_time": self.stringFromDate(self.creationDateTime)
        ]
        
        return returnBody
        
    }
    
}
