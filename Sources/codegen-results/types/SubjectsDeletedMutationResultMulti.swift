import Foundation
import graphql_swift

struct SubjectsDeletedMutationResultMulti: Codable {
    var SubjectsDeleteds: Array<SubjectsDeleted?>?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class SubjectsDeletedMutationResultMultiBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<SubjectsDeletedMutationResultMulti.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: SubjectsDeletedMutationResultMulti.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withSubjectsDeleteds(_ build: (SubjectsDeletedBuilder) -> ()) -> Self {
        let res = SubjectsDeletedBuilder("SubjectsDeleteds")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withMeta(_ build: (MutationResultInfoBuilder) -> ()) -> Self {
        let res = MutationResultInfoBuilder("Meta")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}