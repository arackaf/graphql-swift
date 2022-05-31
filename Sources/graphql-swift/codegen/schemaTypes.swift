import Foundation

func getType(_ json: [String: Any]) -> String {
    let kind: String? = json.get("kind")
    if kind == "LIST" {
        let nestedType = getType(json.val("ofType")!)
        return "Array<\(nestedType)>"
    } else {
        return json.get("name") ?? getType(json.val("ofType")!)
    }
}

public struct GraphqlFieldType: InitializableFromJSON {
    public let name: String
    public let type: String
    
    public init(_ json: [String: Any]){
        name = json.get("name")!
        let typeField = json.val("type")!
        type = getType(typeField)
    }
}

public struct GraphqlInputType: InitializableFromJSON {
    public let name: String
    public let fields: [GraphqlFieldType]
    
    public init(_ json: [String: Any]){
        name = json.get("name")!
        fields = json.arr("inputFields")?.produce() ?? []
    }
}
