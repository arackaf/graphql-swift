let graphqlSchemaInputTypesRequest = """
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
