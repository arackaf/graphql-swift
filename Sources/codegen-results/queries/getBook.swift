import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query getBook ($_id: String, $searchChildSubjects: Boolean, $publicUserId: String, $ver: String, $cache: Int) { 
  getBook (
    _id: $_id
    searchChildSubjects: $searchChildSubjects
    publicUserId: $publicUserId
    ver: $ver
    cache: $cache
)

\(selection)

}
"""
}

struct GetBookFilters: Codable {
    var _id: String?
    var searchChildSubjects: Bool?
    var publicUserId: String?
    var ver: String?
    var cache: Int?
}

func getBook(_ filters: GetBookFilters, buildSelection: (BookSingleQueryResultBuilder) -> ()) throws -> (GenericGraphQLRequest<GetBookFilters>, Codable.Type) {
    let selectionBuilder = BookSingleQueryResultBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<GetBookFilters>(query: query, variables: filters), BookSingleQueryResult.self)
}