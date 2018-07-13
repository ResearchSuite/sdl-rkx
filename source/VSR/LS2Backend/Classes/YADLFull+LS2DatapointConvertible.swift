
import Foundation
import LS2SDK
import Gloss


extension YADLFullRaw: LS2DatapointConvertible {
    public func toDatapoint(builder: LS2DatapointBuilder.Type) -> LS2Datapoint? {
        
        let sourceName = LS2AcquisitionProvenance.defaultAcquisitionSourceName
        let creationDate = self.startDate ?? Date()
        
        guard let schema: LS2Schema = "schemaID" <~~ self.parameters else {
                return nil
        }
        
        let acquisitionSource = LS2AcquisitionProvenance(sourceName: sourceName, sourceCreationDateTime: creationDate, modality: .SelfReported)
        
        guard let body: JSON = {
            return "selections" ~~> self.resultMap
            }() else {
                return nil
        }
        
        let header = LS2DatapointHeader(id: self.uuid, schemaID: schema, acquisitionProvenance: acquisitionSource, metadata: nil)
        return builder.createDatapoint(header: header, body: body)
        
    }
    
}
