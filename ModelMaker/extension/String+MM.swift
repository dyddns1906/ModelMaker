//
//  String+MM.swift
//  ModelMaker
//
//  Created by Yongun Lim on 2023/02/05.
//

import Foundation

extension String {
    func toDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
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
