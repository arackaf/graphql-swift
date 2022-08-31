import Foundation
import graphql_swift

struct SubjectMutationResultMulti: Codable {
    var Subjects: Array<Subject?>?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class SubjectMutationResultMultiBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<SubjectMutationResultMulti.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: SubjectMutationResultMulti.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withSubjects(_ build: (SubjectBuilder) -> ()) -> Self {
        let res = SubjectBuilder("Subjects")
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