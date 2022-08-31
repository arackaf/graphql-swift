import Foundation
import graphql_swift

struct MutationResultInfo: Codable {
    var transaction: Bool?
    var elapsedTime: Int?
 
    enum Fields: String {
        case transaction
        case elapsedTime
    }
}

class MutationResultInfoBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<MutationResultInfo.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: MutationResultInfo.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}