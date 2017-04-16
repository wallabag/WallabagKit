//
//  Extension.swift
//  Pods
//
//  Created by maxime marinel on 16/04/2017.
//
//

import Foundation

extension Dictionary {
    func merge(dict: [Key: Value]) -> [Key: Value] {
        var mutableCopy = self
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}

extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        return dateFormatter.date(from: self)
    }

    var ucFirst: String {
        let first = String(self.characters.prefix(1))

        return first.uppercased() + String(characters.dropFirst())
    }

    var lcFirst: String {
        let first = String(self.characters.prefix(1))

        return first.lowercased() + String(characters.dropFirst())
    }
}
