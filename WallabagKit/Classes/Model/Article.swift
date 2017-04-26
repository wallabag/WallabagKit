//
//  Article.swift
//  Pods
//
//  Created by maxime marinel on 16/04/2017.
//
//

import Foundation

public struct Article {

    public let id: Int
    public let annotations: Set<String>
    public let content: String
    public let createdAt: Date
    public let domainName: String
    public let isArchived: Bool
    public let isStarred: Bool
    public let language: String
    public let mimetype: String
    public let previewPicture: String?
    public let readingTime: Int
    public let tags: Set<Tag>
    public let title: String
    public let updatedAt: Date
    public let url: String
    public let userEmail: String
    public let userId: Int
    public let userName: String

    public init(fromDictionary: [String: Any]) {

        //@todo Failable ?
        id = fromDictionary["id"] as? Int ?? 0

        annotations = []
        content = fromDictionary["content"] as? String ?? ""
        createdAt = (fromDictionary["created_at"] as? String)?.date ?? Date()
        updatedAt = (fromDictionary["updated_at"] as? String)?.date ?? Date()
        domainName = fromDictionary["domain_name"] as? String ?? ""
        isArchived = (fromDictionary["is_archived"] as? Bool) ?? false
        isStarred = (fromDictionary["is_starred"] as? Bool) ?? false
        language = fromDictionary["language"] as? String ?? ""
        mimetype = fromDictionary["mimetype"] as? String ?? ""
        previewPicture = fromDictionary["preview_picture"] as? String
        readingTime = fromDictionary["reading_time"] as? Int ?? 1

        var tagsStack: Set<Tag> = Set()
        if let tags = fromDictionary["tags"] as? [[String: Any]] {
            for tag in tags {
                tagsStack.insert(Tag(fromDictionary: tag))
            }
        }
        self.tags = tagsStack

        title = fromDictionary["title"] as? String ?? ""
        url = fromDictionary["url"] as? String ?? ""
        userEmail = fromDictionary["user_email"] as? String ?? ""
        userId = fromDictionary["user_id"] as? Int ?? 0
        userName = fromDictionary["user_name"] as? String ?? ""
    }
}
