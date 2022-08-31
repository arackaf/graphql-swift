import Foundation
import graphql_swift

struct ScanResult: Codable {
    var success: Bool?
    var isbn: String?
    var title: String?
    var smallImage: String?
 
    enum Fields: String {
        case success
        case isbn
        case title
        case smallImage
    }
}

class ScanResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<ScanResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: ScanResult.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}