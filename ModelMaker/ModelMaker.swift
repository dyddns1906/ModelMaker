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
    
    let jsonString: String? = nil
    let transformDictionary: Dictionary<String, Any?>? = nil
}

extension ModelMaker {
    private func makeModelString() -> String? {
        guard let dic = transformDictionary else { return nil}
        
        let defineRootString = ""
        var result: [String] = []
        
        result.append("import Foundation")
        result.append(inheritType.importString)
        result.enter()
        
        
        result.append("}")
        
        return result.joined(separator: "\n")
    }
    
    private func transformToString() -> String? {
        guard let dic = transformDictionary else { return nil}
        let defineTypeString = defineTypeIsLet ? "let" : "var"
        return dic.map { key, value in
            return ""
        }.joined(separator: "\n")
    }
    
    private func type(of target: Any) -> String {
        return ""
    }
    
    private func defineRoot() -> String {
        
        let typeStirng = isClasses ? "class" : "struct"
        
        return "\(typeStirng) \(rootName): \(inheritType.inheritString) {"
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
        
        var importString: String {
            switch self {
                case .codable:
                    return "import Codable"
                case .objectMapper:
                    return "import ObjectMapper"
            }
        }
    }
}
