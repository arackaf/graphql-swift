import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query allBooks (
  $isbn: String,
  $isbn_in: [String],
  $title_contains: String,
  $userId: String,
  $userId_in: [String],
  $publisher_contains: String,
  $publisher: String,
  $publisher_in: [String],
  $pages_lt: Int,
  $pages_gt: Int,
  $pages: Int,
  $authors_textContains: String,
  $authors_in: [[String]],
  $subjects_count: Int,
  $subjects_containsAny: [String],
  $tags_containsAny: [String],
  $isRead: Boolean,
  $isRead_ne: Boolean,
  $timestamp_lt: Float,
  $timestamp_lte: Float,
  $timestamp_gt: Float,
  $timestamp_gte: Float,
  $OR: [BookFilters],
  $SORT: BookSort,
  $SORTS: [BookSort],
  $LIMIT: Int,
  $SKIP: Int,
  $PAGE: Int,
  $PAGE_SIZE: Int,
  $searchChildSubjects: Boolean,
  $publicUserId: String,
  $ver: String,
  $cache: Int
) { 
  allBooks (
    isbn: $isbn
    isbn_in: $isbn_in
    title_contains: $title_contains
    userId: $userId
    userId_in: $userId_in
    publisher_contains: $publisher_contains
    publisher: $publisher
    publisher_in: $publisher_in
    pages_lt: $pages_lt
    pages_gt: $pages_gt
    pages: $pages
    authors_textContains: $authors_textContains
    authors_in: $authors_in
    subjects_count: $subjects_count
    subjects_containsAny: $subjects_containsAny
    tags_containsAny: $tags_containsAny
    isRead: $isRead
    isRead_ne: $isRead_ne
    timestamp_lt: $timestamp_lt
    timestamp_lte: $timestamp_lte
    timestamp_gt: $timestamp_gt
    timestamp_gte: $timestamp_gte
    OR: $OR
    SORT: $SORT
    SORTS: $SORTS
    LIMIT: $LIMIT
    SKIP: $SKIP
    PAGE: $PAGE
    PAGE_SIZE: $PAGE_SIZE
    searchChildSubjects: $searchChildSubjects
    publicUserId: $publicUserId
    ver: $ver
    cache: $cache
)

\(selection)

}
"""
}

struct AllBooksFilters: Codable {
    var isbn: String?
    var isbn_in: Array<String?>?
    var title_contains: String?
    var userId: String?
    var userId_in: Array<String?>?
    var publisher_contains: String?
    var publisher: String?
    var publisher_in: Array<String?>?
    var pages_lt: Int?
    var pages_gt: Int?
    var pages: Int?
    var authors_textContains: String?
    var authors_in: Array<Array<String?>?>?
    var subjects_count: Int?
    var subjects_containsAny: Array<String?>?
    var tags_containsAny: Array<String?>?
    var isRead: Bool?
    var isRead_ne: Bool?
    var timestamp_lt: Float?
    var timestamp_lte: Float?
    var timestamp_gt: Float?
    var timestamp_gte: Float?
    var OR: Array<BookFilters?>?
    var SORT: BookSort?
    var SORTS: Array<BookSort?>?
    var LIMIT: Int?
    var SKIP: Int?
    var PAGE: Int?
    var PAGE_SIZE: Int?
    var searchChildSubjects: Bool?
    var publicUserId: String?
    var ver: String?
    var cache: Int?
}

func allBooks(_ filters: AllBooksFilters, buildSelection: (BookQueryResultsBuilder) -> ()) throws -> (GenericGraphQLRequest<AllBooksFilters>, Codable.Type) {
    let selectionBuilder = BookQueryResultsBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<AllBooksFilters>(query: query, variables: filters), BookQueryResults.self)
}