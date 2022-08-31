import Foundation
import graphql_swift

struct SubjectSingleQueryResult: Codable {
    var Subject: Subject?
 
    enum Fields: String { case empty }
}

class SubjectSingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<SubjectSingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withSubject(_ build: (SubjectBuilder) -> ()) -> Self {
        let res = SubjectBuilder("Subject")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}