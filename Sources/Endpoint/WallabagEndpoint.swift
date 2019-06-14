//
//  WallabagEndpoint.swift
//  WallabagKit
//
//  Created by maxime marinel on 12/06/2019.
//

import Alamofire
import Foundation

public protocol WallabagEndpoint {
    func getUrl() -> URLConvertible
    func getMethod() -> HTTPMethod
    func getParameters() -> [String: Any]?
}
