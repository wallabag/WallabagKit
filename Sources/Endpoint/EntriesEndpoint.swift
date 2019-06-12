//
//  EntriesEndpoint.swift
//  WallabagKit
//
//  Created by maxime marinel on 12/06/2019.
//

import Alamofire
import Foundation

public enum EntriesEndpoint: WallabagEndpoint {
    public func getUrl() -> URLConvertible {
        switch self {
        case .getAll:
            return "/entries"
        }
    }

    public func getMethod() -> HTTPMethod {
        return .get
    }

    public func getParameters() -> [String: Any]? {
        switch self {
        case let .getAll(page):
            return ["page": page]
        }
    }

    public typealias Page = Int
    case getAll(page: Page)
}
