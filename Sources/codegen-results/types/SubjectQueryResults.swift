import Foundation
import graphql_swift

struct SubjectQueryResults: Codable {
    var Subjects: Array<Subject>?
    var Meta: QueryResultsMetadata?
 
    enum Fields: String { case empty }
}

class SubjectQueryResultsBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<SubjectQueryResults.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withSubjects(_ build: (SubjectBuilder) -> ()) -> Self {
        let res = SubjectBuilder("Subjects")
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