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
    
    open var acquisitionModality: OMHAcquisitionProvenanceModality {
        return .SelfReported
    }
    
    open var acquisitionSourceCreationDateTime: Date {
        return self.startDate ?? Date()
    }
    
    open var acquisitionSourceName: String {
        return OMHAcquisitionProvenance.defaultAcquisitionSourceName
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
