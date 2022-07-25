import Foundation

/* auto generated */
/* ------------------------------------------------ */

struct EditorialReview: Codable {
    enum Fields: String { case source; case review; }
    
    var source: String?
    var review: String?
}

struct Reviewer: Codable {
    enum Fields: String { case id; case name; case address; }
    
    var id: String?
    var name: String?
    var address: String?
}

struct Review: Codable {
    enum Fields: String { case reviewer; case stars; }
    
    var reviewer: Reviewer?
    var stars: Float?
}

// everything's nullable since we don't know which fields the user will query
struct BookFull: Codable {
    enum Fields: String { case id; case title; case isbn; case authors; case pages; case publicationDate; case genres; }
    
    var id: String?
    var title: String?
    var isbn: String?
    var authors: Array<String>?
    var pages: Int?
    var publicationDate: String?
    var genres: Array<String>?
    var editorialReviews: Array<EditorialReview>?
    var reviews: Array<Review>?
}

struct GenreFull: Codable {
    enum Fields: String { case id; case name; }
    
    var id: String?
    var name: String?
}

struct BooksAndSubjectsResult<TBooks: Codable, TSubjects: Codable>: Codable {
    var queryExecutionTime: Int?
    var memoryUsed: Int?
    var queryComplexity: Int?
    
    var Books: TBooks
    var Subjects: TSubjects
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

protocol GraphQLResultSegment {
    func produce() -> String;
}

class ResultBuilder {
    func writeSelection<TEnum: RawRepresentable>(_ name: String, _ fields: [TEnum]) -> String where TEnum.RawValue == String  {
        return ""
    }
}

final class BooksAndSubjectsResultBuilder : ResultBuilder {
    var BookResultType: Codable.Type = BookFull.self
    var GenreResultType: Codable.Type = GenreFull.self
    
    var bookResultFields: [BookFull.Fields] = []
    var genreResultFields: [GenreFull.Fields] = []
    
    func withBooks(_ fields: [BookFull.Fields], serializeInto: Codable.Type? = nil) {
        if (serializeInto != nil) {
            BookResultType = serializeInto!.self
        }
        bookResultFields = fields
    }
    
    func foo() -> BooksAndSubjectsResult<BookFull, BookFull>? {
        return nil
    }
}

/* ------------------------------------------------ */

// but I can write my own type with non-null fields for some queries
struct BookSubType: Codable {
    var id: String
    var title: String
    var authors: Array<String>
}

func junk2() {
    let xxx = BooksAndSubjectsResultBuilder();

    xxx.withBooks([.id, .title, .authors])
    xxx.withBooks([.id, .title, .authors], serializeInto: BookSubType.self)
}





