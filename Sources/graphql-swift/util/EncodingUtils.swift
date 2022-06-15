import Foundation

func encodeValue(fromObjectContainer container: inout KeyedEncodingContainer<JSONCodingKeys>, map: [String:Any?]) throws {
    for k in map.keys {
        let value = map[k]
        let encodingKey = JSONCodingKeys(stringValue: k)
        
        if let value = value as? String {
            try container.encode(value, forKey: encodingKey)
        } else if let value = value as? Int {
            try container.encode(value, forKey: encodingKey)
        } else if let value = value as? Double {
            try container.encode(value, forKey: encodingKey)
        } else if let value = value as? Bool {
            try container.encode(value, forKey: encodingKey)
        } else if let value = value as? [String: Any] {
            var keyedContainer = container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: encodingKey)
            try encodeValue(fromObjectContainer: &keyedContainer, map: value)
        } else if let value = value as? [Any] {
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: encodingKey)
            try encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
        } else {
            try container.encodeNil(forKey: encodingKey)
        }
    }
}

func encodeValue(fromArrayContainer container: inout UnkeyedEncodingContainer, arr: [Any?]) throws {
    for value in arr {
        if let value = value as? String {
            try container.encode(value)
        } else if let value = value as? Int {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? [String: Any] {
            var keyedContainer = container.nestedContainer(keyedBy: JSONCodingKeys.self)
            try encodeValue(fromObjectContainer: &keyedContainer, map: value)
        } else if let value = value as? [Any] {
            var unkeyedContainer = container.nestedUnkeyedContainer()
            try encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
        } else {
            try container.encodeNil()
        }
    }
}
