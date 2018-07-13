
import Foundation
import LS2SDK
import Gloss


extension CTFBARTSummary: LS2DatapointConvertible {
    public func toDatapoint(builder: LS2DatapointBuilder.Type) -> LS2Datapoint? {
        
        let sourceName = LS2AcquisitionProvenance.defaultAcquisitionSourceName
        let creationDate = self.startDate ?? Date()
        
        let acquisitionSource = LS2AcquisitionProvenance(sourceName: sourceName, sourceCreationDateTime: creationDate, modality: .SelfReported)
        
        guard let schema: LS2Schema = LS2Schema(name: "BARTSummary", version: LS2SchemaVersion(major: 1, minor: 1, patch: 0), namespace: "Cornell") else {
            return nil
        }
        
        let header = LS2DatapointHeader(id: self.uuid, schemaID: schema, acquisitionProvenance: acquisitionSource, metadata: nil)
        return builder.createDatapoint(header: header, body: self.dataDictionary())
        
    }
    
}
