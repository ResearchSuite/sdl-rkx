//
//  CTFBARTSummary+OHMDatapoint.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import OMHClient

extension CTFBARTSummary: OMHDataPointBuilder {

    open var creationDateTime: Date {
        return self.startDate ?? Date()
    }
    
    open var dataPointID: String {
        return self.uuid.uuidString
    }
    
    open var acquisitionModality: OMHAcquisitionProvenanceModality {
        return .Sensed
    }
    
    open var acquisitionSourceCreationDateTime: Date {
        return self.startDate ?? Date()
    }
    
    open var acquisitionSourceName: String {
        return OMHAcquisitionProvenance.defaultAcquisitionSourceName
    }
    
    open var schema: OMHSchema {
        return OMHSchema(name: "BARTSummary", version: "1.1.0", namespace: "Cornell")
    }
    
    open var body: [String: Any] {
        return self.dataDictionary()
        
    }

}
