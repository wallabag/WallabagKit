//
//  Entry.swift
//  WallabagKit
//
//  Created by maxime marinel on 08/12/2017.
//

import Foundation

public struct WallabagEntry: Codable {
    public let id: Int
    public let isStarred: Int
    public let userEmail: String
    public let updatedAt: Date
    public let mimetype: String
    public let language: String
    public let previewPicture: String?
    public let readingTime: Int
    //public let tags: [Tag]
    public let isArchived: Int
    public let content: String
    public let domainName: String
    public let createdAt: Date
    public let title: String
    public let userName: String
    public let userId: Int
    //public let annotations: [Annotation]
    public let url: String
    public let httpStatus: String

    enum CodingKeys: String, CodingKey {
        case id
        case isStarred = "is_starred"
        case userEmail = "user_email"
        case updatedAt = "updated_at"
        case mimetype
        case language
        case previewPicture = "preview_picture"
        case readingTime = "reading_time"
        //case tags
        case isArchived = "is_archived"
        case content
        case domainName = "domain_name"
        case createdAt = "created_at"
        case title
        case userName = "user_name"
        case userId = "user_id"
        //case annotations
        case url
        case httpStatus = "http_status"
    }

    public init(from decoder: Decoder) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        isStarred = try container.decode(Int.self, forKey: .isStarred)
        userEmail = try container.decode(String.self, forKey: .userEmail)
        updatedAt = dateFormatter.date(from: try container.decode(String.self, forKey: .updatedAt))!
        mimetype = try container.decode(String.self, forKey: .mimetype)
        language = try container.decode(String.self, forKey: .language)
        previewPicture = try? container.decode(String.self, forKey: .previewPicture)
        readingTime = try container.decode(Int.self, forKey: .readingTime)
        isArchived = try container.decode(Int.self, forKey: .isArchived)
        content = try container.decode(String.self, forKey: .content)
        domainName = try container.decode(String.self, forKey: .domainName)
        createdAt = dateFormatter.date(from: try container.decode(String.self, forKey: .createdAt))!
        title = try container.decode(String.self, forKey: .title)
        userName = try container.decode(String.self, forKey: .userName)
        userId = try container.decode(Int.self, forKey: .userId)
        url = try container.decode(String.self, forKey: .url)
        httpStatus = try container.decode(String.self, forKey: .httpStatus)
    }
}
