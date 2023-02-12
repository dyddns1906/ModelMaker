//
//  String+MM.swift
//  ModelMaker
//
//  Created by Yongun Lim on 2023/02/05.
//

import Foundation

extension String {
    func toDictionary() -> [String:Any]? {
        if let data = self.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
}

extension Array where Element == String {
    mutating func enter() {
        self.append("\n")
    }
}
