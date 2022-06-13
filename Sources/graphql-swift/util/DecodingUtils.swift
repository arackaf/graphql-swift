import Foundation

func decode(fromSingleValue container: SingleValueDecodingContainer) -> Any? {
    if let result = try? container.decode(Int.self) { return result }
    if let result = try? container.decode(Double.self) { return result }
    if let result = try? container.decode(String.self) { return result }
    if let result = try? container.decode(Bool.self) { return result }
    
    return nil
}

func decode(fromContainer container: KeyedDecodingContainer<JSONCodingKeys>) -> [String: Any?] {
    var result: [String: Any?] = [:]

    for key in container.allKeys {
        if let val = try? container.decode(Int.self, forKey: key) { result[key.stringValue] = val }
        else if let val = try? container.decode(Double.self, forKey: key) { result[key.stringValue] = val }
        else if let val = try? container.decode(String.self, forKey: key) { result[key.stringValue] = val }
        else if let val = try? container.decode(Bool.self, forKey: key) { result[key.stringValue] = val }
        else if let nestedContainer = try? container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key) {
            result[key.stringValue] = decode(fromContainer: nestedContainer)
        }
        else if var nestedArray = try? container.nestedUnkeyedContainer(forKey: key) {
            result[key.stringValue] = decode(fromArray: &nestedArray)
        } else if (try? container.decodeNil(forKey: key)) == true  {
            result[key.stringValue] = nil as Any?
        }
    }
    
    return result
}

func decode(fromArray container: inout UnkeyedDecodingContainer) -> [Any?] {
    var result: [Any?] = []

    while container.isAtEnd == false {
        if let value = try? container.decode(String.self) { result.append(value) }
        else if let value = try? container.decode(Int.self) { result.append(value) }
        else if let value = try? container.decode(Double.self) { result.append(value) }
        else if let value = try? container.decode(Bool.self) { result.append(value) }
        else if let nestedContainer = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
            result.append(decode(fromContainer: nestedContainer))
        }
        else if var nestedArray = try? container.nestedUnkeyedContainer() {
            result.append(decode(fromArray: &nestedArray))
        } else if (try? container.decodeNil()) == true {
            result.append(nil)
        }
    }
    
    return result
}
