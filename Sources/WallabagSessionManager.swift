//
//  WallabagAuthApi.swift
//  WallabagKit
//
//  Created by maxime marinel on 04/12/2017.
//  Copyright © 2017 WallabagKit. All rights reserved.
//

import Foundation
import Alamofire

public class WallabagSessionManager {
    internal let host: String
    internal let username: String
    internal let password: String
    internal let clientId: String
    internal let clientSecret: String

    public init(host: String,
                username: String,
                password: String,
                clientId: String,
                clientSecret: String) {
        self.host = host
        self.username = username
        self.password = password
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    public func createSession() -> SessionManager {
        let sessionManager = SessionManager()
        let token = BearerTokenAdapter(baseURLString: host,
                                       clientID: clientId,
                                       clientSecret: clientSecret,
                                       username: username,
                                       password: password)
        sessionManager.adapter = token
        sessionManager.retrier = token

        return sessionManager
    }
}
