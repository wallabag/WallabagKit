//
//  URLSessionProtocol.swift
//  WallabagKit
//
//  Created by maxime marinel on 04/12/2017.
//  Copyright © 2017 WallabagKit. All rights reserved.
//

import Foundation
import Alamofire

public typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

public protocol SessionManagerProtocol {
}

extension SessionManager: SessionManagerProtocol { }
