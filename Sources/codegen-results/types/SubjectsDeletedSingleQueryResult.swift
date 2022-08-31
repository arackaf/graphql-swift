import Foundation
import graphql_swift

struct SubjectsDeletedSingleQueryResult: Codable {
    var SubjectsDeleted: SubjectsDeleted?
 
    enum Fields: String { case empty }
}

class SubjectsDeletedSingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<SubjectsDeletedSingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withSubjectsDeleted(_ build: (SubjectsDeletedBuilder) -> ()) -> Self {
        let res = SubjectsDeletedBuilder("SubjectsDeleted")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}