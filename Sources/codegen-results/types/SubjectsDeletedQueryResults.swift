import Foundation
import graphql_swift

struct SubjectsDeletedQueryResults: Codable {
    var SubjectsDeleteds: Array<SubjectsDeleted>?
    var Meta: QueryResultsMetadata?
 
    enum Fields: String { case empty }
}

class SubjectsDeletedQueryResultsBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<SubjectsDeletedQueryResults.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withSubjectsDeleteds(_ build: (SubjectsDeletedBuilder) -> ()) -> Self {
        let res = SubjectsDeletedBuilder("SubjectsDeleteds")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withMeta(_ build: (QueryResultsMetadataBuilder) -> ()) -> Self {
        let res = QueryResultsMetadataBuilder("Meta")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}