//
//  YADLSpotRaw+OMHDataPoint.swift
//  Pods
//
//  Created by James Kizer on 4/4/17.
//
//

import Foundation
import OMHClient
import Gloss

extension YADLSpotRaw: OMHDataPointBuilder {
    
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
    
    open var header: [String: Any] {
        
        var dict: [String: Any] = [
            "id": self.dataPointID,
            "creation_date_time": self.stringFromDate(self.creationDateTime),
            "schema_id": self.schemaDict,
            "taskIdentifier": self.taskIdentifier,
            "taskRunUUID": self.taskRunUUID.uuidString
        ]
        
        if let acquisitionProvenanceDict = self.acquisitionProvenanceDict {
            dict["acquisition_provenance"] = acquisitionProvenanceDict
        }
        
        if let userInfo = self.userInfo {
            userInfo.forEach({ (pair) in
                dict[pair.0] = pair.1
            })
        }
        
        return dict
    }
    
    open var schema: OMHSchema {
        
        guard let name: String = "name" <~~ self.schemaID,
            let namespace: String = "namespace" <~~ self.schemaID,
            let version: String = "version" <~~ self.schemaID else {
                return OMHSchema(name: "yadl-spot-assessment", version: "2.0", namespace: "Cornell")
        }
        
        return OMHSchema(name: name, version: version, namespace: namespace)
        
    }
    
    open var body: [String: Any] {
        
        return [
            "selected" : self.selected,
            "notSelected": self.notSelected,
            "excluded": self.excluded
        ]
        
    }
    
}
