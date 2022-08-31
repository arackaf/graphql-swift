import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query allSubjectsDeleteds (
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
  $OR: [SubjectsDeletedFilters],
  $SORT: SubjectsDeletedSort,
  $SORTS: [SubjectsDeletedSort],
  $LIMIT: Int,
  $SKIP: Int,
  $PAGE: Int,
  $PAGE_SIZE: Int
) { 
  allSubjectsDeleteds (
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

struct AllSubjectsDeletedsFilters: Codable {
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
    var OR: Array<SubjectsDeletedFilters?>?
    var SORT: SubjectsDeletedSort?
    var SORTS: Array<SubjectsDeletedSort?>?
    var LIMIT: Int?
    var SKIP: Int?
    var PAGE: Int?
    var PAGE_SIZE: Int?
}

func allSubjectsDeleteds(_ filters: AllSubjectsDeletedsFilters, buildSelection: (SubjectsDeletedQueryResultsBuilder) -> ()) throws -> (GenericGraphQLRequest<AllSubjectsDeletedsFilters>, Codable.Type) {
    let selectionBuilder = SubjectsDeletedQueryResultsBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<AllSubjectsDeletedsFilters>(query: query, variables: filters), SubjectsDeletedQueryResults.self)
}