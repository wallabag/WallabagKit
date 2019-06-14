//
//  WallabagKit.swift
//  wallabag
//
//  Created by Marinel maxime on 07/06/2019.
//  Copyright © 2019 wallabag. All rights reserved.
//

import Alamofire
import Foundation

public class WallabagKit {
    let session: SessionManager

    public init(session: SessionManager) {
        self.session = session
    }

    public func request(endpoint: WallabagEndpoint) {
        session.request(endpoint.getUrl(), method: endpoint.getMethod(), parameters: endpoint.getParameters())
    }
}
