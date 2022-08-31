import Foundation
import graphql_swift

struct ScanResults: Codable {
    var ScanResults: Array<ScanResult?>?
    var LastEvaluatedKey: DynamoKey?
 
    enum Fields: String { case empty }
}

class ScanResultsBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<ScanResults.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withScanResults(_ build: (ScanResultBuilder) -> ()) -> Self {
        let res = ScanResultBuilder("ScanResults")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withLastEvaluatedKey(_ build: (DynamoKeyBuilder) -> ()) -> Self {
        let res = DynamoKeyBuilder("LastEvaluatedKey")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}