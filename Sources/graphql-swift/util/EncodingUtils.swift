import Foundation

func encodeValue(fromSingleValueContainer container: inout SingleValueEncodingContainer, value: Any?) {
    if let value = value as? String {
        try? container.encode(value)
    } else if let value = value as? Int {
        try? container.encode(value)
    } else if let value = value as? Double {
        try? container.encode(value)
    } else if let value = value as? Bool {
        try? container.encode(value)
    } else {
        try? container.encodeNil()
    }
}

func encodeValue(fromObjectContainer container: inout KeyedEncodingContainer<JSONCodingKeys>, map: [String:Any?]) {
    for k in map.keys {
        let value = map[k]
        let encodingKey = JSONCodingKeys(stringValue: k)
        
        if let value = value as? String {
            try? container.encode(value, forKey: encodingKey)
        } else if let value = value as? Int {
            try? container.encode(value, forKey: encodingKey)
        } else if let value = value as? Double {
            try? container.encode(value, forKey: encodingKey)
        } else if let value = value as? Bool {
            try? container.encode(value, forKey: encodingKey)
        } else if let value = value as? [String: Any?] {
            var keyedContainer = container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: encodingKey)
            encodeValue(fromObjectContainer: &keyedContainer, map: value)
        } else if let value = value as? [Any?] {
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: encodingKey)
            encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
        } else {
            try? container.encodeNil(forKey: encodingKey)
        }
    }
}

func encodeValue(fromArrayContainer container: inout UnkeyedEncodingContainer, arr: [Any?]) {
    for value in arr {
        if let value = value as? String {
            try? container.encode(value)
        } else if let value = value as? Int {
            try? container.encode(value)
        } else if let value = value as? Double {
            try? container.encode(value)
        } else if let value = value as? Bool {
            try? container.encode(value)
        } else if let value = value as? [String: Any?] {
            var keyedContainer = container.nestedContainer(keyedBy: JSONCodingKeys.self)
            encodeValue(fromObjectContainer: &keyedContainer, map: value)
        } else if let value = value as? [Any?] {
            var unkeyedContainer = container.nestedUnkeyedContainer()
            encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
        } else {
            try? container.encodeNil()
        }
    }
}
