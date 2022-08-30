import Foundation

enum QueryBuildingErrors: String, Error {
    case noResultsSelected
}

public protocol GraphqlResults {
    func emit() throws -> String
}

open class GraphqlResultsSection<Fields: RawRepresentable>: GraphqlResults where Fields.RawValue == String {
    private var name: String = ""
    private var fields: [Fields] = []
    private var otherResults: [GraphqlResults] = []
    
    public func emit() throws -> String {
        let fieldsList = self.fields.map { $0.rawValue }.joined(separator: " ")
        let otherResults = try self.otherResults.map { try $0.emit() }.joined(separator: "\n")

        let allResults = [fieldsList, otherResults].filter({ !$0.isEmpty })
        guard !allResults.isEmpty else {
            throw QueryBuildingErrors.noResultsSelected
        }
        
        return """
\(self.name) {
\(allResults.joined(separator: "\n"))
}
"""
    }
    
    public func withFields(_ fields: Fields...) {
        self.fields = fields
    }
    
    func addResultSet(_ results: GraphqlResults) {
        self.otherResults.append(results)
    }
}


public class Book {
    public enum Fields: String {
        case title
        case author
    }
}

public class BookResults: GraphqlResultsSection<Book.Fields> {
    
}


