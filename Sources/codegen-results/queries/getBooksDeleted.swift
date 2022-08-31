import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query getBooksDeleted ($_id: String) { 
  getBooksDeleted (
    _id: $_id
)

\(selection)

}
"""
}

struct GetBooksDeletedFilters: Codable {
    var _id: String?
}

func getBooksDeleted(_ filters: GetBooksDeletedFilters, buildSelection: (BooksDeletedSingleQueryResultBuilder) -> ()) throws -> (GenericGraphQLRequest<GetBooksDeletedFilters>, Codable.Type) {
    let selectionBuilder = BooksDeletedSingleQueryResultBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<GetBooksDeletedFilters>(query: query, variables: filters), BooksDeletedSingleQueryResult.self)
}