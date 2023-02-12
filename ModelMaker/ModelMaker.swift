//
//  ModelMaker.swift
//  ModelMaker
//
//  Created by Yongun Lim on 2023/02/05.
//

import Foundation

struct ModelMaker {
    
    var inheritType: Types = .codable
    var defineTypeIsLet: Bool = false
    var isClasses: Bool = false
    var rootName: String = "NewModel"
    
    private var transformDictionary: Dictionary<String, Any>? = nil
}

extension ModelMaker {
    func generateSwiftModel(from jsonString: String) -> String {
        guard let dic = jsonString.toDictionary() else { return "" }
        
        var result: [String] = []
        
        result.append("import Foundation")
        result.append("")
        if let importString = inheritType.importString {
            result.append(importString)
        }
        
        result.append(createStructString(withDictionary: dic, andName: rootName))
        
        return result.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func generateObject(contents: [String], name: String) -> String {
        let typeStirng = isClasses ? "class" : "struct"
        return """
        \(typeStirng) \(name): \(inheritType.inheritString) {
        \(contents.joined(separator: "\n"))
        }\n\n
        """
    }
    
    // Create a function that generates structs for inner classes
    private func createStructString(withDictionary dictionary: [String: Any], andName name: String) -> String {
        var properties = [String]()
        var subClass: String = ""
        let defineTypeString = defineTypeIsLet ? "let" : "var"
        for (key, value) in dictionary {
            if let nestedDictionary = value as? [String: Any] {
                let nestedStructString = createStructString(withDictionary: nestedDictionary, andName: key.capitalizingFirstLetter())
                subClass += nestedStructString
                properties.append("\t\(defineTypeString) \(key): \(key.capitalizingFirstLetter())")
            } else if let nestedArray = value as? [[String: Any]] {
                let nestedStructName = "\(key.capitalizingFirstLetter())"
                let nestedStructString = createArrayStructString(withArray: nestedArray, andName: nestedStructName)
                subClass += nestedStructString
                properties.append("\t\(defineTypeString) \(key): [\(nestedStructName)]")
            } else {
                let property = "\t\(defineTypeString) \(key): \(getType(of: value))"
                properties.append(property)
            }
        }
        
        subClass = subClass.isEmpty ? "" : "\(subClass)"
        
        return generateObject(contents: properties, name: name) + subClass
    }
    
    // Create a function that generates structs for arrays of inner classes
    private func createArrayStructString(withArray array: [[String: Any]], andName name: String) -> String {
        if let firstDictionary = array.first {
            return createStructString(withDictionary: firstDictionary, andName: name)
        }
        return ""
    }
    
    private func getType(of value: Any) -> String {
        switch value {
            case is Bool:
                return "Bool"
            case is NSNumber:
                if value is Int {
                    return "Int"
                } else if value is Double {
                    return "Double"
                }
                return "Double"
            case is String:
                return "String"
            default:
                return "Any"
        }
    }
}

extension ModelMaker {
    enum Types: String {
        case codable, objectMapper
        
        var inheritString: String {
            switch self {
                case .codable:
                    return "Codable"
                case .objectMapper:
                    return "Mapper"
            }
        }
        
        var importString: String? {
            switch self {
                case .objectMapper:
                    return "import ObjectMapper"
                default:
                    return nil
            }
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


