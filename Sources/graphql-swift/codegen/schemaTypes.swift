import Foundation

public extension Dictionary where Key == String {
    func val(_ key: String) -> [String: Any]? {
        return self[key] as? [String:Any]
    }
    
    func arr(_ key: String) -> [[String: Any]]? {
        return self[key] as? [[String:Any]]
    }
    
    func get<T>(_ key: String) -> T? {
        return self[key] as? T
    }
}

public extension Array where Element == Dictionary<String, Any> {
    func produce<T>() -> [T]? where T: InitializableFromJSON {
        return self.map { T($0) }
    }
}

public protocol InitializableFromJSON {
    init(_ json: [String: Any])
}

public struct GraphqlFieldType: InitializableFromJSON {
    public let name: String
    public let type: String
    
    static func getType(_ json: [String: Any]) -> String {
        let kind: String? = json.get("kind")
        if kind == "LIST" {
            let nestedType = getType(json.val("ofType")!)
            return "Array<\(nestedType)>"
        } else {
            return json.get("name") ?? getType(json.val("ofType")!)
        }
    }
    
    public init(_ json: [String: Any]){
        name = json.get("name")!
        let typeField = json.val("type")!
        type = Self.getType(typeField)
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
