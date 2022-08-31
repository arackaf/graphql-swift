import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query allSubjects (
  $name_contains: String,
  $name_startsWith: String,
  $name_endsWith: String,
  $name_regex: String,
  $name: String,
  $name_ne: String,
  $name_in: [String],
  $name_nin: [String],
  $path_contains: String,
  $path_startsWith: String,
  $path: String,
  $userId: String,
  $userId_in: [String],
  $timestamp_lt: Float,
  $timestamp_gt: Float,
  $OR: [SubjectFilters],
  $SORT: SubjectSort,
  $SORTS: [SubjectSort],
  $LIMIT: Int,
  $SKIP: Int,
  $PAGE: Int,
  $PAGE_SIZE: Int,
  $publicUserId: String,
  $ver: String,
  $cache: Int
) { 
  allSubjects (
    name_contains: $name_contains
    name_startsWith: $name_startsWith
    name_endsWith: $name_endsWith
    name_regex: $name_regex
    name: $name
    name_ne: $name_ne
    name_in: $name_in
    name_nin: $name_nin
    path_contains: $path_contains
    path_startsWith: $path_startsWith
    path: $path
    userId: $userId
    userId_in: $userId_in
    timestamp_lt: $timestamp_lt
    timestamp_gt: $timestamp_gt
    OR: $OR
    SORT: $SORT
    SORTS: $SORTS
    LIMIT: $LIMIT
    SKIP: $SKIP
    PAGE: $PAGE
    PAGE_SIZE: $PAGE_SIZE
    publicUserId: $publicUserId
    ver: $ver
    cache: $cache
)

\(selection)

}
"""
}

struct AllSubjectsFilters: Codable {
    var name_contains: String?
    var name_startsWith: String?
    var name_endsWith: String?
    var name_regex: String?
    var name: String?
    var name_ne: String?
    var name_in: Array<String?>?
    var name_nin: Array<String?>?
    var path_contains: String?
    var path_startsWith: String?
    var path: String?
    var userId: String?
    var userId_in: Array<String?>?
    var timestamp_lt: Float?
    var timestamp_gt: Float?
    var OR: Array<SubjectFilters?>?
    var SORT: SubjectSort?
    var SORTS: Array<SubjectSort?>?
    var LIMIT: Int?
    var SKIP: Int?
    var PAGE: Int?
    var PAGE_SIZE: Int?
    var publicUserId: String?
    var ver: String?
    var cache: Int?
}

func allSubjects(_ filters: AllSubjectsFilters, buildSelection: (SubjectQueryResultsBuilder) -> ()) throws -> (GenericGraphQLRequest<AllSubjectsFilters>, Codable.Type) {
    let selectionBuilder = SubjectQueryResultsBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<AllSubjectsFilters>(query: query, variables: filters), SubjectQueryResults.self)
}