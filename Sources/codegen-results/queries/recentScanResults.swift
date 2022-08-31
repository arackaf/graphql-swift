import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query recentScanResults ($exclusiveStartKey: DynamoKeyInput) { 
  recentScanResults (
    exclusiveStartKey: $exclusiveStartKey
)

\(selection)

}
"""
}

struct RecentScanResultsFilters: Codable {
    var exclusiveStartKey: DynamoKeyInput?
}

func recentScanResults(_ filters: RecentScanResultsFilters, buildSelection: (ScanResultsBuilder) -> ()) throws -> (GenericGraphQLRequest<RecentScanResultsFilters>, Codable.Type) {
    let selectionBuilder = ScanResultsBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<RecentScanResultsFilters>(query: query, variables: filters), ScanResults?.self)
}