import Foundation
import graphql_swift

struct Mutation: Codable {
    var createBook: BookMutationResult?
    var updateBook: BookMutationResult?
    var updateBooks: BookMutationResultMulti?
    var updateBooksBulk: BookBulkMutationResult?
    var deleteBook: DeletionResultInfo?
    var updateBookSummary: BookSummaryMutationResult?
    var createSubject: SubjectMutationResult?
    var updateSubject: SubjectMutationResultMulti?
    var deleteSubject: Array<String?>?
    var createTag: TagMutationResult?
    var updateTag: TagMutationResult?
    var updateTags: TagMutationResultMulti?
    var updateTagsBulk: TagBulkMutationResult?
    var deleteTag: DeletionResultInfo?
    var updateUser: UserSingleQueryResult?
 
    enum Fields: String {
        case deleteSubject
    }
}

class MutationBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<Mutation.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: Mutation.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withCreateBook(_ build: (BookMutationResultBuilder) -> ()) -> Self {
        let res = BookMutationResultBuilder("createBook")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withUpdateBook(_ build: (BookMutationResultBuilder) -> ()) -> Self {
        let res = BookMutationResultBuilder("updateBook")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withUpdateBooks(_ build: (BookMutationResultMultiBuilder) -> ()) -> Self {
        let res = BookMutationResultMultiBuilder("updateBooks")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withUpdateBooksBulk(_ build: (BookBulkMutationResultBuilder) -> ()) -> Self {
        let res = BookBulkMutationResultBuilder("updateBooksBulk")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withDeleteBook(_ build: (DeletionResultInfoBuilder) -> ()) -> Self {
        let res = DeletionResultInfoBuilder("deleteBook")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withUpdateBookSummary(_ build: (BookSummaryMutationResultBuilder) -> ()) -> Self {
        let res = BookSummaryMutationResultBuilder("updateBookSummary")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withCreateSubject(_ build: (SubjectMutationResultBuilder) -> ()) -> Self {
        let res = SubjectMutationResultBuilder("createSubject")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withUpdateSubject(_ build: (SubjectMutationResultMultiBuilder) -> ()) -> Self {
        let res = SubjectMutationResultMultiBuilder("updateSubject")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withCreateTag(_ build: (TagMutationResultBuilder) -> ()) -> Self {
        let res = TagMutationResultBuilder("createTag")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withUpdateTag(_ build: (TagMutationResultBuilder) -> ()) -> Self {
        let res = TagMutationResultBuilder("updateTag")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withUpdateTags(_ build: (TagMutationResultMultiBuilder) -> ()) -> Self {
        let res = TagMutationResultMultiBuilder("updateTags")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withUpdateTagsBulk(_ build: (TagBulkMutationResultBuilder) -> ()) -> Self {
        let res = TagBulkMutationResultBuilder("updateTagsBulk")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withDeleteTag(_ build: (DeletionResultInfoBuilder) -> ()) -> Self {
        let res = DeletionResultInfoBuilder("deleteTag")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withUpdateUser(_ build: (UserSingleQueryResultBuilder) -> ()) -> Self {
        let res = UserSingleQueryResultBuilder("updateUser")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}