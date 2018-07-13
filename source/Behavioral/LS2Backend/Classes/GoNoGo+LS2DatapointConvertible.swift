
import Foundation
import LS2SDK
import Gloss


extension CTFGoNoGoSummary: LS2DatapointConvertible {
    public func toDatapoint(builder: LS2DatapointBuilder.Type) -> LS2Datapoint? {
        
        let sourceName = LS2AcquisitionProvenance.defaultAcquisitionSourceName
        let creationDate = self.startDate ?? Date()
        
        let acquisitionSource = LS2AcquisitionProvenance(sourceName: sourceName, sourceCreationDateTime: creationDate, modality: .SelfReported)
        
        guard let schema: LS2Schema = LS2Schema(name: "GoNoGoSummary", version: LS2SchemaVersion(major: 1, minor: 1, patch: 0), namespace: "Cornell") else {
            return nil
        }
        
        let body: JSON = {
            return [
                "total": self.totalSummary.toDict(),
                "firstThird": self.firstThirdSummary.toDict(),
                "middleThird": self.middleThirdSummary.toDict(),
                "lastThird": self.lastThirdSummary.toDict()
            ]
        }()
        
        let header = LS2DatapointHeader(id: self.uuid, schemaID: schema, acquisitionProvenance: acquisitionSource, metadata: nil)
        return builder.createDatapoint(header: header, body: body)
        
    }
    
}
