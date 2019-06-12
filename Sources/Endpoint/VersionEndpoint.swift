//
//  VersionEndpoint.swift
//  WallabagKit
//
//  Created by maxime marinel on 12/06/2019.
//

import Alamofire
import Foundation

public enum VersionEndpoint: WallabagEndpoint {
    public func getUrl() -> URLConvertible {
        switch self {
        case .getVersion:
            return "/version"
        }
    }

    public func getMethod() -> HTTPMethod {
        return .get
    }

    public func getParameters() -> [String: Any]? {
        return nil
    }

    case getVersion
}
