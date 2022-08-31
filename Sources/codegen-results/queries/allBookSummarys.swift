import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query allBookSummarys (
  $title_contains: String,
  $title_startsWith: String,
  $title_endsWith: String,
  $title_regex: String,
  $title: String,
  $title_ne: String,
  $title_in: [String],
  $title_nin: [String],
  $asin: String,
  $asin_in: [String],
  $isbn: String,
  $isbn_in: [String],
  $smallImage_contains: String,
  $smallImage: String,
  $authors_count: Int,
  $authors_textContains: String,
  $authors_startsWith: String,
  $authors_endsWith: String,
  $authors_regex: String,
  $authors: [String],
  $authors_in: [[String]],
  $authors_nin: [[String]],
  $authors_contains: String,
  $authors_containsAny: [String],
  $authors_containsAll: [String],
  $authors_ne: [String],
  $OR: [BookSummaryFilters],
  $SORT: BookSummarySort,
  $SORTS: [BookSummarySort],
  $LIMIT: Int,
  $SKIP: Int,
  $PAGE: Int,
  $PAGE_SIZE: Int
) { 
  allBookSummarys (
    title_contains: $title_contains
    title_startsWith: $title_startsWith
    title_endsWith: $title_endsWith
    title_regex: $title_regex
    title: $title
    title_ne: $title_ne
    title_in: $title_in
    title_nin: $title_nin
    asin: $asin
    asin_in: $asin_in
    isbn: $isbn
    isbn_in: $isbn_in
    smallImage_contains: $smallImage_contains
    smallImage: $smallImage
    authors_count: $authors_count
    authors_textContains: $authors_textContains
    authors_startsWith: $authors_startsWith
    authors_endsWith: $authors_endsWith
    authors_regex: $authors_regex
    authors: $authors
    authors_in: $authors_in
    authors_nin: $authors_nin
    authors_contains: $authors_contains
    authors_containsAny: $authors_containsAny
    authors_containsAll: $authors_containsAll
    authors_ne: $authors_ne
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

struct AllBookSummarysFilters: Codable {
    var title_contains: String?
    var title_startsWith: String?
    var title_endsWith: String?
    var title_regex: String?
    var title: String?
    var title_ne: String?
    var title_in: Array<String?>?
    var title_nin: Array<String?>?
    var asin: String?
    var asin_in: Array<String?>?
    var isbn: String?
    var isbn_in: Array<String?>?
    var smallImage_contains: String?
    var smallImage: String?
    var authors_count: Int?
    var authors_textContains: String?
    var authors_startsWith: String?
    var authors_endsWith: String?
    var authors_regex: String?
    var authors: Array<String?>?
    var authors_in: Array<Array<String?>?>?
    var authors_nin: Array<Array<String?>?>?
    var authors_contains: String?
    var authors_containsAny: Array<String?>?
    var authors_containsAll: Array<String?>?
    var authors_ne: Array<String?>?
    var OR: Array<BookSummaryFilters?>?
    var SORT: BookSummarySort?
    var SORTS: Array<BookSummarySort?>?
    var LIMIT: Int?
    var SKIP: Int?
    var PAGE: Int?
    var PAGE_SIZE: Int?
}

func allBookSummarys(_ filters: AllBookSummarysFilters, buildSelection: (BookSummaryQueryResultsBuilder) -> ()) throws -> (GenericGraphQLRequest<AllBookSummarysFilters>, Codable.Type) {
    let selectionBuilder = BookSummaryQueryResultsBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<AllBookSummarysFilters>(query: query, variables: filters), BookSummaryQueryResults.self)
}