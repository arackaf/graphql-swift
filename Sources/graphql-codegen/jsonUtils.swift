import Foundation

protocol InitializableFromJSON {
    init(json: [String: Any])
}

extension Dictionary where Key == String {
    func object(_ key: String) -> [String: Any]? {
        return self[key] as? [String: Any]
    }
    
    func array(_ key: String) -> [[String: Any]]? {
        return self[key] as? [[String:Any]]
    }
    
    func get<T>(_ key: String) -> T? {
        return self[key] as? T
    }
}

extension Array where Element == Dictionary<String, Any> {
    func produce<T>() -> [T]? where T: InitializableFromJSON {
        return self.map(T.init(json:))
    }
}
