import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query allBooksDeleteds (
  $_id: String,
  $_id_ne: String,
  $_id_in: [String],
  $_id_nin: [String],
  $userId_contains: String,
  $userId_startsWith: String,
  $userId_endsWith: String,
  $userId_regex: String,
  $userId: String,
  $userId_ne: String,
  $userId_in: [String],
  $userId_nin: [String],
  $deletedTimestamp_lt: Float,
  $deletedTimestamp_gt: Float,
  $OR: [BooksDeletedFilters],
  $SORT: BooksDeletedSort,
  $SORTS: [BooksDeletedSort],
  $LIMIT: Int,
  $SKIP: Int,
  $PAGE: Int,
  $PAGE_SIZE: Int
) { 
  allBooksDeleteds (
    _id: $_id
    _id_ne: $_id_ne
    _id_in: $_id_in
    _id_nin: $_id_nin
    userId_contains: $userId_contains
    userId_startsWith: $userId_startsWith
    userId_endsWith: $userId_endsWith
    userId_regex: $userId_regex
    userId: $userId
    userId_ne: $userId_ne
    userId_in: $userId_in
    userId_nin: $userId_nin
    deletedTimestamp_lt: $deletedTimestamp_lt
    deletedTimestamp_gt: $deletedTimestamp_gt
    OR: $OR
    SORT: $SORT
    SORTS: $SORTS
    LIMIT: $LIMIT
    SKIP: $SKIP
    PAGE: $PAGE
    PAGE_SIZE: $PAGE_SIZE
)

\(selection)

}
"""
}

struct AllBooksDeletedsFilters: Codable {
    var _id: String?
    var _id_ne: String?
    var _id_in: Array<String?>?
    var _id_nin: Array<String?>?
    var userId_contains: String?
    var userId_startsWith: String?
    var userId_endsWith: String?
    var userId_regex: String?
    var userId: String?
    var userId_ne: String?
    var userId_in: Array<String?>?
    var userId_nin: Array<String?>?
    var deletedTimestamp_lt: Float?
    var deletedTimestamp_gt: Float?
    var OR: Array<BooksDeletedFilters?>?
    var SORT: BooksDeletedSort?
    var SORTS: Array<BooksDeletedSort?>?
    var LIMIT: Int?
    var SKIP: Int?
    var PAGE: Int?
    var PAGE_SIZE: Int?
}

func allBooksDeleteds(_ filters: AllBooksDeletedsFilters, buildSelection: (BooksDeletedQueryResultsBuilder) -> ()) throws -> (GenericGraphQLRequest<AllBooksDeletedsFilters>, Codable.Type) {
    let selectionBuilder = BooksDeletedQueryResultsBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<AllBooksDeletedsFilters>(query: query, variables: filters), BooksDeletedQueryResults.self)
}