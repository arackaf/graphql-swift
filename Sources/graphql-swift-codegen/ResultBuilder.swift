import Foundation

/* auto generated */
/* ------------------------------------------------ */

enum BookFields: String {
    case id; case title; case isbn; case authors; case pages; case publicationDate; case genres;
}

enum GenreFields: String {
    case id; case name;
}

enum QueryMetadataFields: String {
    case queryExecutionTime; case memoryUsed;
}

// everything's nullable since we don't know which fields the user will query
struct BookFull: Codable {
    var id: String?
    var title: String?
    var isbn: String?
    var authors: Array<String>?
    var pages: Int?
    var publicationDate: String?
    var genres: Array<String>?
}

struct GenreFull: Codable {
    var id: String?
    var name: String?
}

struct QueryMetadata: Codable {
    var queryExecutionTime: Int?
    var memoryUsed: Int?
}

struct BooksAndSubjectsResult<TBooks: Codable, TSubjects: Codable, TMetadata: Codable>: Codable {
    var Books: TBooks
    var Subjects: TSubjects
    var MetaData: TMetadata
}

/**

 Graphql schema has a query, say BooksAndSubjects, which returns a result of
    {
        Books: [BookFull],
        Subjects: [SubjectFull],
        Metadata: QueryMetadata
    }
 
    from which we can query arbitrarily - ie select any sub-graph therefrom - ie the Graph in GraphQL
*/

protocol x: RawRepresentable {
    
}

class ResultBuilder {
    func writeSelection<TEnum: RawRepresentable>(_ name: String, _ fields: [TEnum]) -> String where TEnum.RawValue == String  {
        return ""
    }
}

final class BooksAndSubjectsResultBuilder : ResultBuilder {
    var BookResultType: Codable.Type = BookFull.self
    var GenreResultType: Codable.Type = GenreFull.self
    var MetadataResultType: Codable.Type = QueryMetadata.self
    
    var bookResultFields: [BookFields] = []
    var genreResultFields: [GenreFields] = []
    var metadataResultFields: [BookFields] = []
    
    func x() -> String {
        
        return """
            {
                \(writeSelection("Books", bookResultFields))
                \(writeSelection("Genres", genreResultFields))
                \(writeSelection("Meta", metadataResultFields))
            }
        """
    }
    
    func foo() -> BooksAndSubjectsResult<BookFull, BookFull, BookFull>? {
        return nil
    }
}



/* ------------------------------------------------ */
