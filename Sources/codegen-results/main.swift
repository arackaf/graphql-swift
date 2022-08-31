import Foundation

print("Helloooo")

func foo() throws {
    var filters = AllBooksFilters()
    filters.title_contains = "Jefferson"
    
    let result = try allBooks(filters) { res in
        res
            .withBooks {
                $0.withFields(.title)
                $0.withEditorialReviews { $0.withFields(.source, .content) }
                $0.withSimilarBooks { $0.withFields(.title) }
            }
            .withMeta {
                $0.withFields(.count)
            }
    }
    
    print(result)
}

try? foo()
