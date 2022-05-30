public let GRAPHQL_SCHEMA_INPUT_TYPES_REQUEST = """
{
  __schema {
    types {
      kind
      name
      inputFields{
        name
        type {
          name
          kind
          ofType {
            name
            kind
            ofType {
              name
              kind
              ofType {
                name
                kind
              }
            }
          }
        }
      }
    }
  }
}
"""
