
import Foundation
import LS2SDK
import Gloss


extension CTFDiscountingRaw: LS2DatapointConvertible {
    public func toDatapoint(builder: LS2DatapointBuilder.Type) -> LS2Datapoint? {
        
        let sourceName = LS2AcquisitionProvenance.defaultAcquisitionSourceName
        let creationDate = self.startDate ?? Date()
        
        let acquisitionSource = LS2AcquisitionProvenance(sourceName: sourceName, sourceCreationDateTime: creationDate, modality: .SelfReported)
        
        guard let schema: LS2Schema = LS2Schema(name: "discounting-raw", version: LS2SchemaVersion(major: 1, minor: 0, patch: 0), namespace: "Cornell") else {
            return nil
        }
        
        let body: JSON = {
            return [
                "variable_label": self.variableLabel,
                "variable_array": self.variableArray,
                "constant_array": self.constantArray,
                "choice_array": self.choiceArray,
                "times": self.times
            ]
        }()
        
        let header = LS2DatapointHeader(id: self.uuid, schemaID: schema, acquisitionProvenance: acquisitionSource, metadata: nil)
        return builder.createDatapoint(header: header, body: body)
        
    }
    
}

extension CTFDelayDiscountingRaw: LS2DatapointConvertible {
    public func toDatapoint(builder: LS2DatapointBuilder.Type) -> LS2Datapoint? {
        
        let sourceName = LS2AcquisitionProvenance.defaultAcquisitionSourceName
        let creationDate = self.startDate ?? Date()
        
        let acquisitionSource = LS2AcquisitionProvenance(sourceName: sourceName, sourceCreationDateTime: creationDate, modality: .SelfReported)
        
        guard let schema: LS2Schema = LS2Schema(name: "delay-discounting-raw", version: LS2SchemaVersion(major: 1, minor: 0, patch: 0), namespace: "Cornell") else {
            return nil
        }
        
        let body: JSON = {
            return [
                "variable_label": self.variableLabel,
                "now_array": self.nowArray,
                "later_array": self.laterArray,
                "choice_array": self.choiceArray,
                "times": self.times
            ]
        }()
        
        let header = LS2DatapointHeader(id: self.uuid, schemaID: schema, acquisitionProvenance: acquisitionSource, metadata: nil)
        return builder.createDatapoint(header: header, body: body)
        
    }
    
}
