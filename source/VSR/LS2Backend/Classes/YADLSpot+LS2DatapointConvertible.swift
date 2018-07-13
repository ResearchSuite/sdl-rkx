
import Foundation
import LS2SDK
import Gloss

extension YADLSpotRaw: LS2DatapointConvertible {
    public func toDatapoint(builder: LS2DatapointBuilder.Type) -> LS2Datapoint? {
        
        let sourceName = LS2AcquisitionProvenance.defaultAcquisitionSourceName
        let creationDate = self.startDate ?? Date()
        
        guard let schema: LS2Schema = "schemaID" <~~ self.parameters else {
            return nil
        }
        
        let acquisitionSource = LS2AcquisitionProvenance(sourceName: sourceName, sourceCreationDateTime: creationDate, modality: .SelfReported)
        
        guard let body: JSON = {
            
            let selectedMap: [String: String] = Dictionary.init(uniqueKeysWithValues: self.selected.map { ($0, "selected") } )
            let notSelectedMap: [String: String] = Dictionary.init(uniqueKeysWithValues: self.notSelected.map { ($0, "not selected") } )
            let excludedMap: [String: String] = Dictionary.init(uniqueKeysWithValues: self.excluded.map { ($0, "excluded") } )
            
            let fullMap: [String: String] = [selectedMap, notSelectedMap, excludedMap].reduce([String: String](), { (acc, map) -> [String: String] in
                return acc.merging(map, uniquingKeysWith: {
                    first, second in
                    return first
                    
                })
            })
            
            return fullMap
            
            }() else {
                return nil
        }
        
        let header = LS2DatapointHeader(id: self.uuid, schemaID: schema, acquisitionProvenance: acquisitionSource, metadata: nil)
        return builder.createDatapoint(header: header, body: body)
        
    }
    
}
