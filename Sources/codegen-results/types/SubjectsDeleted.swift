import Foundation
import graphql_swift

struct SubjectsDeleted: Codable {
    var _id: String?
    var userId: String?
    var deletedTimestamp: Float?
 
    enum Fields: String {
        case _id
        case userId
        case deletedTimestamp
    }
}

class SubjectsDeletedBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<SubjectsDeleted.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: SubjectsDeleted.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}